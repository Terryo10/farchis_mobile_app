import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/notification/notification_event.dart';
import '../../../blocs/notification/notification_state.dart';
import '../../../data/models/notification_model.dart';

@RoutePage()
class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications on enter
    context.read<NotificationBloc>().add(const GetNotificationsEvent());
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'booking_confirmed':
      case 'booking_completed':
      case 'booking':
        return Icons.calendar_today_rounded;
      case 'loyalty_reward':
      case 'loyalty':
        return Icons.stars_rounded;
      case 'scratch_card':
        return Icons.confirmation_number_rounded;
      case 'review':
        return Icons.rate_review_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getNotificationColor(String type, bool isDark) {
    switch (type.toLowerCase()) {
      case 'booking_confirmed':
      case 'booking_completed':
      case 'booking':
        return isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
      case 'loyalty_reward':
      case 'loyalty':
        return AppColors.tierGold;
      case 'scratch_card':
        return isDark ? AppColors.darkInfo : AppColors.lightInfo;
      default:
        return themePrimaryColor;
    }
  }

  Color get themePrimaryColor => AppColors.navyPrimary;

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              final hasUnread = state.notifications.any((n) => !n.isRead);
              if (!hasUnread) return const SizedBox.shrink();

              return TextButton(
                onPressed: () {
                  context.read<NotificationBloc>().add(const MarkAllNotificationsReadEvent());
                },
                child: const Text('Mark all read'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          final isLoading = state.isLoading && state.notifications.isEmpty;

          if (state.failure != null && state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 48),
                  const SizedBox(height: AppDimensions.md),
                  Text(state.failure!.message),
                  const SizedBox(height: AppDimensions.lg),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationBloc>().add(const GetNotificationsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final notifications = isLoading
              ? NotificationModel.placeholderList(6)
              : state.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'No notifications yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return Skeletonizer(
            enabled: isLoading,
            effect: ShimmerEffect(
              baseColor: const Color(0xFF253971).withValues(alpha: 0.08),
              highlightColor: const Color(0xFF253971).withValues(alpha: 0.15),
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(const GetNotificationsEvent());
              },
              child: ListView.separated(
                itemCount: notifications.length,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg,
                  vertical: AppDimensions.md,
                ),
                separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.sm),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(context, theme, isDark, notification);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    NotificationModel notification,
  ) {
    final typeColor = _getNotificationColor(notification.type, isDark);
    final isUnread = !notification.isRead;

    return GestureDetector(
      onTap: () {
        if (isUnread) {
          context.read<NotificationBloc>().add(MarkNotificationReadEvent(notification.id));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: isUnread
              ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.05)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isUnread
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.outline.withValues(alpha: 0.1),
            width: isUnread ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: isUnread ? 0.04 : 0.01),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: isDark ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                size: AppDimensions.iconSm,
                color: typeColor,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Text(
                        _formatDateTime(notification.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    notification.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: isUnread ? 0.8 : 0.6),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: AppDimensions.sm),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
