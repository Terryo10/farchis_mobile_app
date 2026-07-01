import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/chat/conversations_bloc.dart';
import '../../../blocs/chat/conversations_event.dart';
import '../../../blocs/chat/conversations_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/conversation_model.dart';
import '../../router/app_router.dart';

@RoutePage()
class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ConversationsBloc>().add(const LoadConversations());
  }

  String _title(ConversationModel conversation) {
    switch (conversation.type) {
      case ConversationType.inspection:
        return 'Inspection Support';
      case ConversationType.general:
        return 'Farchis Support';
    }
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
        title: const Text('Chat'),
        elevation: 0,
      ),
      body: BlocBuilder<ConversationsBloc, ConversationsState>(
        builder: (context, state) {
          if (state.isLoading && state.conversations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final failure = state.failure;
          if (failure != null && state.conversations.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.xxxl),
                child: Text(failure.message, textAlign: TextAlign.center),
              ),
            );
          }

          if (state.conversations.isEmpty) {
            return Center(
              child: Text(
                'No conversations yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ConversationsBloc>().add(const LoadConversations());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.lg),
              itemCount: state.conversations.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppDimensions.md),
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                final unread = conversation.unreadCount ?? 0;
                return Material(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    onTap: () => context.router.push(
                      ChatThreadRoute(conversationId: conversation.id),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.navyLight.withValues(alpha: 0.3)
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                (isDark
                                        ? AppColors.navyLight
                                        : AppColors.navyPrimary)
                                    .withValues(alpha: 0.15),
                            child: Icon(
                              Icons.support_agent_rounded,
                              color: isDark
                                  ? AppColors.navyLight
                                  : AppColors.navyPrimary,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _title(conversation),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  conversation.lastMessageAt != null
                                      ? DateFormat(
                                          'dd MMM, HH:mm',
                                        ).format(conversation.lastMessageAt!)
                                      : 'No messages yet',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (unread > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusCircle,
                                ),
                              ),
                              child: Text(
                                unread > 9 ? '9+' : unread.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            Icon(
                              Icons.chevron_right_rounded,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
