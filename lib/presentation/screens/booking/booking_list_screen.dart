import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/status_badge.dart';
import '../../router/app_router.dart';

@RoutePage()
class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen>
    with SingleTickerProviderStateMixin {
  int _selectedFilterIndex = 0;
  late final AnimationController _staggerController;

  static const _filters = ['All', 'Upcoming', 'In Progress', 'Completed'];

  static const _mockBookings = [
    _MockBooking(
      icon: Icons.build_circle_outlined,
      iconColor: AppColors.categoryMaintenance,
      serviceName: 'Full Service',
      vehicle: 'BMW 320i • ABC-1234',
      dateTime: 'Today, 10:30 AM',
      status: AppConstants.bookingStatusInProgress,
    ),
    _MockBooking(
      icon: Icons.oil_barrel_outlined,
      iconColor: AppColors.categoryRepair,
      serviceName: 'Oil Change',
      vehicle: 'Mercedes C200 • DEF-5678',
      dateTime: 'Tomorrow, 09:00 AM',
      status: AppConstants.bookingStatusConfirmed,
    ),
    _MockBooking(
      icon: Icons.auto_awesome_outlined,
      iconColor: AppColors.categoryDetailing,
      serviceName: 'Full Detailing',
      vehicle: 'BMW 320i • ABC-1234',
      dateTime: 'Jun 25, 2:00 PM',
      status: AppConstants.bookingStatusPending,
    ),
    _MockBooking(
      icon: Icons.disc_full_outlined,
      iconColor: AppColors.categoryRepair,
      serviceName: 'Brake Inspection',
      vehicle: 'Toyota Hilux • GHI-9012',
      dateTime: 'Jun 18, 11:00 AM',
      status: AppConstants.bookingStatusCompleted,
    ),
    _MockBooking(
      icon: Icons.tire_repair_outlined,
      iconColor: AppColors.categoryCustom,
      serviceName: 'Tire Rotation',
      vehicle: 'Mercedes C200 • DEF-5678',
      dateTime: 'Jun 15, 3:30 PM',
      status: AppConstants.bookingStatusCompleted,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  List<_MockBooking> get _filteredBookings {
    switch (_selectedFilterIndex) {
      case 1: // Upcoming
        return _mockBookings
            .where((b) =>
                b.status == AppConstants.bookingStatusConfirmed ||
                b.status == AppConstants.bookingStatusPending)
            .toList();
      case 2: // In Progress
        return _mockBookings
            .where((b) => b.status == AppConstants.bookingStatusInProgress)
            .toList();
      case 3: // Completed
        return _mockBookings
            .where((b) => b.status == AppConstants.bookingStatusCompleted)
            .toList();
      default:
        return _mockBookings;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bookings = _filteredBookings;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.huge + 20),
        child: FloatingActionButton.extended(
          onPressed: () => context.router.push(const CreateBookingRoute()),
          backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          foregroundColor: isDark ? AppColors.darkOnPrimary : AppColors.lightOnPrimary,
          elevation: 6,
          icon: const Icon(Icons.add_rounded, size: 22),
          label: Text(
            'Book Service',
            style: theme.textTheme.labelLarge?.copyWith(
              color: isDark ? AppColors.darkOnPrimary : AppColors.lightOnPrimary,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // --- Custom SliverAppBar ---
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: isDark ? AppColors.navyDarkest : AppColors.navyPrimary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDark ? AppColors.navyDark : AppColors.navyPrimary,
                      isDark ? AppColors.navyDarkest : AppColors.navyDark,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.xxl,
                      AppDimensions.lg,
                      AppDimensions.xxl,
                      AppDimensions.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'My Bookings',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          '${_mockBookings.length} total bookings',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // --- Filter Chips ---
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusXl),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.xxl,
                  AppDimensions.xxl,
                  AppDimensions.xxl,
                  AppDimensions.md,
                ),
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppDimensions.sm),
                    itemBuilder: (context, index) {
                      final isSelected = _selectedFilterIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedFilterIndex = index);
                          _staggerController.reset();
                          _staggerController.forward();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.lg,
                            vertical: AppDimensions.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusCircle,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : theme.colorScheme.outline,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _filters[index],
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isSelected
                                    ? (isDark
                                        ? AppColors.darkOnPrimary
                                        : AppColors.lightOnPrimary)
                                    : theme.textTheme.bodyMedium?.color,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // --- Booking List or Empty State ---
          if (bookings.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyBookingsView(isDark: isDark, theme: theme),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.xxl,
                AppDimensions.md,
                AppDimensions.xxl,
                120,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final booking = bookings[index];
                    final itemDelay = index / bookings.length;
                    final animation = CurvedAnimation(
                      parent: _staggerController,
                      curve: Interval(
                        itemDelay * 0.6,
                        (itemDelay * 0.6 + 0.4).clamp(0.0, 1.0),
                        curve: Curves.easeOutCubic,
                      ),
                    );

                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: animation.value,
                          child: Transform.translate(
                            offset: Offset(0, 24 * (1 - animation.value)),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.md,
                        ),
                        child: _BookingCard(
                          booking: booking,
                          isDark: isDark,
                          theme: theme,
                          onTap: () =>
                              context.router.push(const JobTrackerRoute()),
                        ),
                      ),
                    );
                  },
                  childCount: bookings.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------- AnimatedBuilder helper (same as AnimatedWidget) ----------
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

// ---------- Booking Card ----------
class _BookingCard extends StatefulWidget {
  final _MockBooking booking;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;

  const _BookingCard({
    required this.booking,
    required this.isDark,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: widget.theme.cardTheme.color,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: widget.isDark
                  ? AppColors.navyLight.withOpacity(0.4)
                  : AppColors.lightBorder,
            ),
            boxShadow: [
              if (!widget.isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Row(
              children: [
                // Service icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: widget.booking.iconColor.withOpacity(0.12),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Icon(
                    widget.booking.icon,
                    color: widget.booking.iconColor,
                    size: AppDimensions.iconLg,
                  ),
                ),
                const SizedBox(width: AppDimensions.lg),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.booking.serviceName,
                        style: widget.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: widget.theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        widget.booking.vehicle,
                        style: widget.theme.textTheme.bodySmall?.copyWith(
                          color: widget.isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: widget.isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                          ),
                          const SizedBox(width: AppDimensions.xs),
                          Text(
                            widget.booking.dateTime,
                            style:
                                widget.theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: widget.isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status & chevron
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StatusBadge(
                      status: widget.booking.status,
                      compact: true,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: AppDimensions.iconSm,
                      color: widget.isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Empty State ----------
class _EmptyBookingsView extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _EmptyBookingsView({required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.navyLight.withOpacity(0.2)
                    : AppColors.silverLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: AppDimensions.iconXl,
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            Text(
              'No Bookings Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Your upcoming and past bookings\nwill appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Mock Data Model ----------
class _MockBooking {
  final IconData icon;
  final Color iconColor;
  final String serviceName;
  final String vehicle;
  final String dateTime;
  final String status;

  const _MockBooking({
    required this.icon,
    required this.iconColor,
    required this.serviceName,
    required this.vehicle,
    required this.dateTime,
    required this.status,
  });
}
