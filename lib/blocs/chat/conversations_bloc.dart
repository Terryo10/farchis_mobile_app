import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/chat_repository.dart';
import 'conversations_event.dart';
import 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final ChatRepository repository;

  ConversationsBloc({required this.repository}) : super(const ConversationsState()) {
    on<LoadConversations>(_onLoad);
  }

  Future<void> _onLoad(LoadConversations event, Emitter<ConversationsState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await repository.getConversations();
    result.when(
      onSuccess: (conversations) => emit(state.copyWith(conversations: conversations, isLoading: false)),
      onFailure: (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
    );
  }
}
