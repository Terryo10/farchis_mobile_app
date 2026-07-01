import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/pusher_service.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'chat_thread_event.dart';
import 'chat_thread_state.dart';

class ChatThreadBloc extends Bloc<ChatThreadEvent, ChatThreadState> {
  final ChatRepository repository;
  final PusherService pusherService;
  final int conversationId;

  ChatThreadBloc({
    required this.repository,
    required this.pusherService,
    required this.conversationId,
  }) : super(const ChatThreadState()) {
    on<LoadMessages>(_onLoad);
    on<SendChatMessage>(_onSend);
    on<MarkThreadRead>(_onMarkRead);
    on<RealtimeMessageReceived>(_onRealtimeMessage);

    _subscribe();
  }

  Future<void> _subscribe() async {
    try {
      await pusherService.subscribe(
        channelName: PusherService.privateChannel('conversation.$conversationId'),
        onEvent: (event) {
          if (event.eventName != 'chat.message.sent') return;
          try {
            final raw = event.data;
            final decoded = raw is String ? json.decode(raw) : raw;
            final messageJson = (decoded as Map)['message'] as Map<String, dynamic>;
            add(RealtimeMessageReceived(ChatMessageModel.fromJson(messageJson)));
          } catch (_) {}
        },
      );
    } catch (_) {
      // Real-time is a nice-to-have here — the thread still works via polling
      // reloads/manual refresh if the socket can't connect.
    }
  }

  Future<void> _onLoad(LoadMessages event, Emitter<ChatThreadState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await repository.getMessages(conversationId);
    result.when(
      onSuccess: (messages) {
        // API returns newest-first; reverse for a bottom-anchored chat UI.
        final ordered = messages.reversed.toList();
        emit(state.copyWith(messages: ordered, isLoading: false));
      },
      onFailure: (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
    );
  }

  Future<void> _onSend(SendChatMessage event, Emitter<ChatThreadState> emit) async {
    if ((event.body == null || event.body!.isEmpty) && event.attachmentPaths.isEmpty) return;

    emit(state.copyWith(isSending: true, failure: null));
    final result = await repository.sendMessage(
      conversationId,
      body: event.body,
      attachmentPaths: event.attachmentPaths,
    );
    result.when(
      onSuccess: (message) {
        if (state.messages.any((m) => m.id == message.id)) {
          emit(state.copyWith(isSending: false));
          return;
        }
        final updated = List.of(state.messages)..add(message);
        emit(state.copyWith(messages: updated, isSending: false));
      },
      onFailure: (failure) => emit(state.copyWith(isSending: false, failure: failure)),
    );
  }

  Future<void> _onMarkRead(MarkThreadRead event, Emitter<ChatThreadState> emit) async {
    await repository.markRead(conversationId);
  }

  void _onRealtimeMessage(RealtimeMessageReceived event, Emitter<ChatThreadState> emit) {
    if (state.messages.any((m) => m.id == event.message.id)) return;
    final updated = List.of(state.messages)..add(event.message);
    emit(state.copyWith(messages: updated));
  }

  @override
  Future<void> close() {
    pusherService.unsubscribe(PusherService.privateChannel('conversation.$conversationId'));
    return super.close();
  }
}
