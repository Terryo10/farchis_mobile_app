import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/farchis_button.dart';

import '../../../data/models/booking_model.dart';

@RoutePage()
class JobTrackerScreen extends StatefulWidget {
  final BookingModel booking;
  const JobTrackerScreen({super.key, required this.booking});

  @override
  State<JobTrackerScreen> createState() => _JobTrackerScreenState();
}

class _JobTrackerScreenState extends State<JobTrackerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  List<_ServiceStage> get _stages {
    final status = widget.booking.status;

    int activeIndex = -1;
    if (status == BookingStatus.pending || status == BookingStatus.confirmed || status == BookingStatus.in_queue) {
      activeIndex = 0;
    } else if (status == BookingStatus.being_assessed) {
      activeIndex = 1;
    } else if (status == BookingStatus.in_progress) {
      activeIndex = 2;
    } else if (status == BookingStatus.ready) {
      activeIndex = 3;
    } else if (status == BookingStatus.completed) {
      activeIndex = 4;
    }

    _StageStatus getStatus(int index) {
      if (status == BookingStatus.cancelled) return _StageStatus.pending;
      if (index < activeIndex) return _StageStatus.completed;
      if (index == activeIndex) return _StageStatus.active;
      return _StageStatus.pending;
    }

    return [
      _ServiceStage(
        title: 'Checked In',
        description: 'Vehicle received at service center',
        time: activeIndex >= 0 ? widget.booking.bookingTime : '--',
        status: getStatus(0),
      ),
      _ServiceStage(
        title: 'Diagnosis',
        description: 'System diagnostic in progress.',
        time: '--',
        status: getStatus(1),
      ),
      _ServiceStage(
        title: 'In Progress',
        description: 'Technician is working on your vehicle.',
        time: '--',
        status: getStatus(2),
      ),
      _ServiceStage(
        title: 'Ready for Pickup',
        description: 'Your vehicle is ready to be collected',
        time: '--',
        status: getStatus(3),
      ),
      _ServiceStage(
        title: 'Completed',
        description: 'Vehicle collected.',
        time: '--',
        status: getStatus(4),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.onSurface,
          ),
        ),
        title: Text(
          'Job Tracker',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.xxl,
          AppDimensions.sm,
          AppDimensions.xxl,
          AppDimensions.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Vehicle Info Header ---
            _VehicleInfoCard(isDark: isDark, theme: theme),
            const SizedBox(height: AppDimensions.xxl),

            // --- Estimated Completion ---
            _EstimatedTimeCard(isDark: isDark, theme: theme),
            const SizedBox(height: AppDimensions.xxl),

            // --- Timeline ---
            Text(
              'Service Progress',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            ...List.generate(_stages.length, (index) {
              final stage = _stages[index];
              final isLast = index == _stages.length - 1;
              return _TimelineStep(
                stage: stage,
                isLast: isLast,
                isDark: isDark,
                theme: theme,
                pulseController: _pulseController,
              );
            }),

            const SizedBox(height: AppDimensions.xxxl),

            // --- Contact Button ---
            FarchisButton(
              label: 'Contact Service Advisor',
              variant: ButtonVariant.secondary,
              size: ButtonSize.large,
              width: double.infinity,
              icon: Icon(
                Icons.headset_mic_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Connecting to your advisor...'),
                    backgroundColor:
                        isDark ? AppColors.darkInfo : AppColors.lightInfo,
                  ),
                );
              },
            ),
            const SizedBox(height: AppDimensions.md),
            FarchisButton(
              label: 'Call Service Center',
              variant: ButtonVariant.text,
              size: ButtonSize.medium,
              width: double.infinity,
              icon: Icon(
                Icons.phone_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {},
            ),
            const SizedBox(height: AppDimensions.huge),
          ],
        ),
      ),
    );
  }
}

// =================== Vehicle Info Card ===================
class _VehicleInfoCard extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _VehicleInfoCard({required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? AppColors.navyDark : AppColors.navyPrimary,
            isDark ? AppColors.navyDarkest : AppColors.navyDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDarkest.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Row(
          children: [
            // Car icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: const Icon(
                Icons.directions_car_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: AppDimensions.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BMW 320i',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.confirmation_number_outlined,
                        label: 'ABC-1234',
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      _InfoChip(
                        icon: Icons.build_circle_outlined,
                        label: 'Full Service',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: AppDimensions.xs),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// =================== Estimated Time Card ===================
class _EstimatedTimeCard extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _EstimatedTimeCard({required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    final successColor =
        isDark ? AppColors.darkSuccess : AppColors.lightSuccess;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: successColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: successColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: successColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.timer_outlined,
              color: successColor,
              size: 22,
            ),
          ),
          const SizedBox(width: AppDimensions.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Completion',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs / 2),
                Text(
                  'Today, 2:30 PM',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            decoration: BoxDecoration(
              color: successColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Text(
              '~4h left',
              style: theme.textTheme.labelMedium?.copyWith(
                color: successColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =================== Timeline Step ===================
class _TimelineStep extends StatelessWidget {
  final _ServiceStage stage;
  final bool isLast;
  final bool isDark;
  final ThemeData theme;
  final AnimationController pulseController;

  const _TimelineStep({
    required this.stage,
    required this.isLast,
    required this.isDark,
    required this.theme,
    required this.pulseController,
  });

  Color _dotColor() {
    switch (stage.status) {
      case _StageStatus.completed:
        return isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
      case _StageStatus.active:
        return isDark ? AppColors.darkInfo : AppColors.lightInfo;
      case _StageStatus.pending:
        return isDark
            ? AppColors.darkTextTertiary.withValues(alpha: 0.3)
            : AppColors.lightTextTertiary.withValues(alpha: 0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = _dotColor();
    final isActive = stage.status == _StageStatus.active;
    final isCompleted = stage.status == _StageStatus.completed;
    final isPending = stage.status == _StageStatus.pending;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column (dot + line)
          SizedBox(
            width: 36,
            child: Column(
              children: [
                // Dot
                isActive
                    ? AnimatedBuilder(
                        animation: pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dotColor,
                              boxShadow: [
                                BoxShadow(
                                  color: dotColor.withValues(
                                      alpha: 0.3 + 0.3 * pulseController.value),
                                  blurRadius:
                                      8 + 8 * pulseController.value,
                                  spreadRadius: 2 * pulseController.value,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: isCompleted ? 24 : 20,
                        height: isCompleted ? 24 : 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted ? dotColor : Colors.transparent,
                          border: isPending
                              ? Border.all(
                                  color: dotColor,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                // Line
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.xs,
                      ),
                      child: isPending || stage.status == _StageStatus.active
                          ? CustomPaint(
                              painter: _DashedLinePainter(
                                color: isDark
                                    ? AppColors.darkTextTertiary
                                        .withValues(alpha: 0.2)
                                    : AppColors.lightTextTertiary
                                        .withValues(alpha: 0.3),
                              ),
                              child: const SizedBox(width: 2),
                            )
                          : Container(
                              width: 2,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkSuccess
                                    : AppColors.lightSuccess,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppDimensions.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stage.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight:
                                isActive ? FontWeight.w800 : FontWeight.w600,
                            color: isPending
                                ? theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4)
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (stage.time != '--')
                        Text(
                          stage.time,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    stage.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isPending
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                          : isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                      height: 1.5,
                    ),
                  ),
                  if (isActive) ...[
                    const SizedBox(height: AppDimensions.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md,
                        vertical: AppDimensions.sm,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark
                                ? AppColors.darkInfo
                                : AppColors.lightInfo)
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: isDark
                                ? AppColors.darkInfo
                                : AppColors.lightInfo,
                          ),
                          const SizedBox(width: AppDimensions.xs),
                          Text(
                            'Technician: John M.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkInfo
                                  : AppColors.lightInfo,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reused AnimatedBuilder from booking_list_screen
class AnimatedBuilder extends AnimatedWidget {
  final TransitionBuilder builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) => builder(context, child);
}

// =================== Dashed Line Painter ===================
class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashHeight = 5.0;
    const dashSpace = 4.0;
    double startY = 0;
    final centerX = size.width / 2;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(centerX, startY),
        Offset(centerX, math.min(startY + dashHeight, size.height)),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      color != oldDelegate.color;
}

// =================== Data Models ===================
enum _StageStatus { completed, active, pending }

class _ServiceStage {
  final String title;
  final String description;
  final String time;
  final _StageStatus status;

  const _ServiceStage({
    required this.title,
    required this.description,
    required this.time,
    required this.status,
  });
}
