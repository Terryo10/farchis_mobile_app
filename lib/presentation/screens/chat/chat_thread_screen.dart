import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/chat/chat_thread_bloc.dart';
import '../../../blocs/chat/chat_thread_event.dart';
import '../../../blocs/chat/chat_thread_state.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/chat_message_model.dart';

@RoutePage()
class ChatThreadScreen extends StatelessWidget {
  final int conversationId;
  const ChatThreadScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatThreadBloc(
              repository: Injection.chatRepository,
              pusherService: Injection.pusherService,
              conversationId: conversationId,
            )
            ..add(const LoadMessages())
            ..add(const MarkThreadRead()),
      child: _ChatThreadView(conversationId: conversationId),
    );
  }
}

class _ChatThreadView extends StatefulWidget {
  final int conversationId;
  const _ChatThreadView({required this.conversationId});

  @override
  State<_ChatThreadView> createState() => _ChatThreadViewState();
}

class _ChatThreadViewState extends State<_ChatThreadView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send(BuildContext context) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatThreadBloc>().add(SendChatMessage(body: text));
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.navyDark : AppColors.navyPrimary,
        foregroundColor: AppColors.white,
        title: const Text('Farchis Support'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatThreadBloc, ChatThreadState>(
              listener: (context, state) {
                if (state.messages.isNotEmpty) _scrollToBottom();
                final failure = state.failure;
                if (failure != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(failure.message)));
                }
              },
              builder: (context, state) {
                if (state.isLoading && state.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Say hello 👋',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return _MessageBubble(message: message, isDark: isDark);
                  },
                );
              },
            ),
          ),
          _buildComposer(context, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildComposer(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.sm,
        AppDimensions.md,
        MediaQuery.of(context).padding.bottom + AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.navyDark : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.navyLight.withValues(alpha: 0.3)
                : AppColors.lightBorder,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<ChatThreadBloc, ChatThreadState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type a message…',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md,
                        vertical: AppDimensions.sm,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXl,
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _send(context),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                IconButton(
                  onPressed: state.isSending ? null : () => _send(context),
                  icon: state.isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          Icons.send_rounded,
                          color: isDark
                              ? AppColors.navyLight
                              : AppColors.navyPrimary,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isDark;

  const _MessageBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFromUser = message.isFromUser;
    final bubbleColor = isFromUser
        ? (isDark ? AppColors.navyLight : AppColors.navyPrimary)
        : (isDark ? AppColors.navyDark : AppColors.lightSurface);
    final textColor = isFromUser
        ? AppColors.white
        : theme.colorScheme.onSurface;

    return Align(
      alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.sm),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppDimensions.radiusMd),
            topRight: const Radius.circular(AppDimensions.radiusMd),
            bottomLeft: Radius.circular(
              isFromUser ? AppDimensions.radiusMd : 2,
            ),
            bottomRight: Radius.circular(
              isFromUser ? 2 : AppDimensions.radiusMd,
            ),
          ),
          border: isFromUser
              ? null
              : Border.all(
                  color: isDark
                      ? AppColors.navyLight.withValues(alpha: 0.3)
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.body != null && message.body!.isNotEmpty)
              Text(message.body!, style: TextStyle(color: textColor)),
            const SizedBox(height: 2),
            Text(
              DateFormat('HH:mm').format(message.createdAt.toLocal()),
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
