import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/notification_prefs/notification_prefs_bloc.dart';
import '../../../blocs/notification_prefs/notification_prefs_event.dart';
import '../../../blocs/notification_prefs/notification_prefs_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

@RoutePage()
class NotificationPrefsScreen extends StatefulWidget {
  const NotificationPrefsScreen({super.key});

  @override
  State<NotificationPrefsScreen> createState() =>
      _NotificationPrefsScreenState();
}

class _NotificationPrefsScreenState extends State<NotificationPrefsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<NotificationPrefsBloc>()
        .add(const LoadNotificationPrefs());
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
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: BlocBuilder<NotificationPrefsBloc, NotificationPrefsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            children: [
              const SizedBox(height: AppDimensions.sm),
              Text(
                'NOTIFICATION PREFERENCES',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              _buildGroup(context, theme, isDark, state),
              const SizedBox(height: AppDimensions.xxl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
                child: Text(
                  'You can always change these preferences at any time.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroup(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    NotificationPrefsState state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.black : AppColors.navyDarkest)
                .withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: NotifPrefKeys.all.map((key) {
          final isLast = key == NotifPrefKeys.all.last;
          return Column(
            children: [
              _PrefToggleRow(
                key: ValueKey(key),
                prefKey: key,
                label: NotifPrefKeys.labels[key] ?? key,
                subtitle: NotifPrefKeys.subtitles[key],
                value: state.get(key),
                isDark: isDark,
                onToggle: () => context
                    .read<NotificationPrefsBloc>()
                    .add(ToggleNotificationPref(key)),
              ),
              if (!isLast)
                Padding(
                  padding:
                      const EdgeInsets.only(left: AppDimensions.lg + 36 + AppDimensions.md),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _PrefToggleRow extends StatelessWidget {
  final String prefKey;
  final String label;
  final String? subtitle;
  final bool value;
  final bool isDark;
  final VoidCallback onToggle;

  const _PrefToggleRow({
    super.key,
    required this.prefKey,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.md + 2,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: (_) => onToggle(),
              activeThumbColor: isDark ? AppColors.darkInfo : AppColors.lightInfo,
            ),
          ],
        ),
      ),
    );
  }
}
