import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/chat_message_model.dart';

class ChatThreadState extends Equatable {
  final List<ChatMessageModel> messages; // oldest first
  final bool isLoading;
  final bool isSending;
  final Failure? failure;

  const ChatThreadState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.failure,
  });

  ChatThreadState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    bool? isSending,
    Failure? failure,
  }) {
    return ChatThreadState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, isSending, failure];
}
