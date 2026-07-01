import 'package:equatable/equatable.dart';
import '../../data/models/chat_message_model.dart';

sealed class ChatThreadEvent extends Equatable {
  const ChatThreadEvent();
  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatThreadEvent {
  const LoadMessages();
}

class SendChatMessage extends ChatThreadEvent {
  final String? body;
  final List<String> attachmentPaths;
  const SendChatMessage({this.body, this.attachmentPaths = const []});
  @override
  List<Object?> get props => [body, attachmentPaths];
}

class MarkThreadRead extends ChatThreadEvent {
  const MarkThreadRead();
}

/// Dispatched internally when a `chat.message.sent` Reverb event arrives on
/// this conversation's private channel.
class RealtimeMessageReceived extends ChatThreadEvent {
  final ChatMessageModel message;
  const RealtimeMessageReceived(this.message);
  @override
  List<Object?> get props => [message];
}
