import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../blocs/booking/booking_bloc.dart';
import '../../../data/models/booking_model.dart';

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

  List<BookingModel> _getFilteredBookings(List<BookingModel> allBookings) {
    switch (_selectedFilterIndex) {
      case 1: // Upcoming
        return allBookings
            .where((b) =>
                b.status == BookingStatus.confirmed ||
                b.status == BookingStatus.pending)
            .toList();
      case 2: // In Progress
        return allBookings
            .where((b) => b.status == BookingStatus.in_progress)
            .toList();
      case 3: // Completed
        return allBookings
            .where((b) => b.status == BookingStatus.completed)
            .toList();
      default:
        return allBookings;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(LoadBookings());
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final isLoading = state is BookingLoading || state is BookingInitial;
          if (state is BookingError) {
            return Center(child: Text('Failed to load bookings: ${state.failure.message}'));
          }

          List<BookingModel> bookings = [];
          if (state is BookingsLoaded) {
            final allBookings = [...state.active, ...state.past];
            bookings = _getFilteredBookings(allBookings);
          } else {
            bookings = BookingModel.placeholderList(4);
          }

          return Skeletonizer(
            enabled: isLoading,
            effect: ShimmerEffect(
              baseColor: const Color(0xFF253971).withValues(alpha: 0.08),
              highlightColor: const Color(0xFF253971).withValues(alpha: 0.15),
            ),
            child: CustomScrollView(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'My Bookings',
                                    style: theme.textTheme.displaySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Material(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                                    child: InkWell(
                                      onTap: () => context.router.push(const CreateBookingRoute()),
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppDimensions.md,
                                          vertical: AppDimensions.sm,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                                            const SizedBox(width: AppDimensions.xs),
                                            Text(
                                              'Book',
                                              style: theme.textTheme.labelMedium?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.xs),
                              Text(
                                '${bookings.length} total bookings',
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
                          separatorBuilder: (_, _) =>
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
                if (bookings.isEmpty && !isLoading)
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
                              final opacity = isLoading ? 1.0 : animation.value;
                              final offset = isLoading ? 0.0 : 24 * (1 - animation.value);
                              return Opacity(
                                opacity: opacity,
                                child: Transform.translate(
                                  offset: Offset(0, offset),
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
                                    context.router.push(JobTrackerRoute(booking: booking)),
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
        },
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
  final BookingModel booking;
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
                  ? AppColors.navyLight.withValues(alpha: 0.4)
                  : AppColors.lightBorder,
            ),
            boxShadow: [
              if (!widget.isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
                    color: AppColors.categoryMaintenance.withValues(alpha: 0.12),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Icon(
                    Icons.build_circle_outlined,
                    color: AppColors.categoryMaintenance,
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
                        widget.booking.service.name,
                        style: widget.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: widget.theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        'Booking ID: #${widget.booking.id}',
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
                            '${widget.booking.bookingDate.toLocal().toString().split(' ')[0]} ${widget.booking.bookingTime}',
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
                      status: widget.booking.status.name,
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
                    ? AppColors.navyLight.withValues(alpha: 0.2)
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


