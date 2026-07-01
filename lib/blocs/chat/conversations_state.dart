import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/conversation_model.dart';

class ConversationsState extends Equatable {
  final List<ConversationModel> conversations;
  final bool isLoading;
  final Failure? failure;

  const ConversationsState({
    this.conversations = const [],
    this.isLoading = false,
    this.failure,
  });

  ConversationsState copyWith({
    List<ConversationModel>? conversations,
    bool? isLoading,
    Failure? failure,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [conversations, isLoading, failure];
}
