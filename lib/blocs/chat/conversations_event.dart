import 'package:equatable/equatable.dart';

sealed class ConversationsEvent extends Equatable {
  const ConversationsEvent();
  @override
  List<Object?> get props => [];
}

class LoadConversations extends ConversationsEvent {
  const LoadConversations();
}
