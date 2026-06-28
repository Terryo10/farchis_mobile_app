import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/booking/booking_bloc.dart';
import '../../../data/models/booking_model.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/status_badge.dart';
import '../../router/app_router.dart';
import '../../../blocs/promotion/promotion_bloc.dart';
import '../../../blocs/promotion/promotion_event.dart';
import '../../../blocs/promotion/promotion_state.dart';
import '../../../data/models/promotion_model.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/notification/notification_event.dart';
import '../../../blocs/notification/notification_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_state.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  static const int _cardCount = 4;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const GetNotificationsEvent());
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimations = List.generate(_cardCount, (index) {
      final start = index * 0.15;
      final end = start + 0.5;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
              curve: Curves.easeOutCubic),
        ),
      );
    });

    _slideAnimations = List.generate(_cardCount, (index) {
      final start = index * 0.15;
      final end = start + 0.5;
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
              curve: Curves.easeOutCubic),
        ),
      );
    });

    _staggerController.forward();
    context.read<PromotionBloc>().add(const GetPromotionsEvent());
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
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(theme, isDark),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusXl),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Services Grid ---
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.xxl,
                        AppDimensions.xxl,
                        AppDimensions.xxl,
                        0,
                      ),
                      child: Text(
                        'Services',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _buildServicesGrid(context),

                    // --- Recent Bookings ---
                    const SizedBox(height: AppDimensions.xxxl),
                    _buildRecentBookings(context, theme, isDark),

                    // --- Special Offers ---
                    const SizedBox(height: AppDimensions.xxxl),
                    _buildSpecialOffers(context, theme, isDark),

                    // Bottom padding for floating nav
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Sliver App Bar
  // ──────────────────────────────────────────────────────────────────────────

  SliverAppBar _buildSliverAppBar(ThemeData theme, bool isDark) {
    return SliverAppBar(
      expandedHeight: 290,
      pinned: true,
      backgroundColor: isDark ? AppColors.navyDarkest : AppColors.navyPrimary,
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
              padding: const EdgeInsets.all(AppDimensions.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _greeting,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xB3FFFFFF), // white70
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    'Welcome to Farchis Automotive',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: AppColors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xxl),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      final isAuthenticated = authState is Authenticated;
                      final label = isAuthenticated ? authState.user.name : 'Guest — sign in';
                      final vehicleLabel = (isAuthenticated && authState.user.vehicleMake != null)
                          ? '${authState.user.vehicleMake} ${authState.user.vehicleModel}'
                          : 'Add Vehicle';

                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.router.push(const ProfileRoute()),
                            child: _GlassStatusChip(
                              icon: Icons.person_outline_rounded,
                              label: label,
                              brightness: 1.0,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.md),
                          GestureDetector(
                            onTap: () => context.router.push(const ProfileRoute()),
                            child: _GlassStatusChip(
                              icon: Icons.directions_car_rounded,
                              label: vehicleLabel,
                              brightness: 0.7,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppDimensions.lg),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            final unreadCount = state.notifications.where((n) => !n.isRead).length;

            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded,
                      color: AppColors.white),
                  onPressed: () {
                    context.router.push(const NotificationListRoute());
                  },
                  tooltip: 'Notifications',
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: AppDimensions.xs),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Services Grid (animated + Material InkWell)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildServicesGrid(BuildContext context) {
    final cards = [
      _ActionCardData(
        icon: Icons.build_circle_outlined,
        label: 'Book Service',
        onTap: () => context.router.push(const CreateBookingRoute()),
      ),
      _ActionCardData(
        icon: Icons.local_shipping_outlined,
        label: 'Request pickup',
        onTap: () => context.router.push(DriverConvenienceMapRoute()),
      ),
      _ActionCardData(
        icon: Icons.confirmation_num_outlined,
        label: 'Scratch Card',
        onTap: () => context.router.push(const ScratchCardRoute()),
      ),
      _ActionCardData(
        icon: Icons.directions_car_outlined,
        label: 'My Garage',
        onTap: () {},
      ),
    ];

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppDimensions.lg,
        crossAxisSpacing: AppDimensions.lg,
        childAspectRatio: 1.1,
        children: List.generate(cards.length, (index) {
          final card = cards[index];
          return AnimatedBuilder(
            animation: _staggerController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimations[index],
                child: SlideTransition(
                  position: _slideAnimations[index],
                  child: child,
                ),
              );
            },
            child: _ActionCard(
              icon: card.icon,
              label: card.label,
              onTap: card.onTap,
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Recent Bookings
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildRecentBookings(
      BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Bookings', style: theme.textTheme.titleLarge),
              TextButton(
                onPressed: () => context.router.push(const BookingListRoute()),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View All',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            final isLoading = state is BookingLoading || state is BookingInitial;
            if (state is BookingError) {
              return const SizedBox();
            }

            final bookings = state is BookingsLoaded
                ? state.active.take(3).toList()
                : BookingModel.placeholderList(3);

            if (state is BookingsLoaded && bookings.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.xl),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.navyDark : AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    border: Border.all(
                      color: isDark ? AppColors.navyLight : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 48,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Text(
                        'No recent bookings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        'Your booking history will appear here',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor: const Color(0xFF253971).withValues(alpha: 0.08),
                highlightColor: const Color(0xFF253971).withValues(alpha: 0.15),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
                children: bookings
                    .map((b) => _BookingCard(booking: b, isDark: isDark))
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Special Offers
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildSpecialOffers(
      BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
          child: Text('Special Offers', style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: AppDimensions.md),
        BlocBuilder<PromotionBloc, PromotionState>(
          builder: (context, state) {
            final isLoading = state is PromotionLoading || state is PromotionInitial;
            if (state is PromotionLoadFailed) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
                child: Text('Failed to load special offers'),
              );
            }

            final offers = state is PromotionsLoaded
                ? state.promotions
                : PromotionModel.placeholderList(3);

            if (state is PromotionsLoaded && offers.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
                child: Text('No special offers at the moment', style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                )),
              );
            }

            return Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor: const Color(0xFF253971).withValues(alpha: 0.08),
                highlightColor: const Color(0xFF253971).withValues(alpha: 0.15),
              ),
              child: SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.xxl),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < offers.length - 1
                            ? AppDimensions.lg
                            : 0,
                      ),
                      child: _OfferCard(offer: offer, isDark: isDark),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Glassmorphism Status Chip
// ═══════════════════════════════════════════════════════════════════════════

class _GlassStatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final double brightness;

  const _GlassStatusChip({
    required this.icon,
    required this.label,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor =
        brightness >= 1.0 ? AppColors.white : const Color(0xB3FFFFFF);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          decoration: BoxDecoration(
            color: const Color(0x1AFFFFFF), // white ~10%
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(color: const Color(0x33FFFFFF)), // white ~20%
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppDimensions.iconXs, color: labelColor),
              const SizedBox(width: AppDimensions.sm - 2),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Action Card (Material InkWell + gradient press overlay)
// ═══════════════════════════════════════════════════════════════════════════

class _ActionCardData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCardData({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: widget.label,
      child: Material(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(
              color: isDark ? AppColors.navyLight : AppColors.lightBorder,
            ),
            boxShadow: [
              if (!isDark)
                const BoxShadow(
                  color: Color(0x08000000), // black ~3%
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
            ],
            gradient: _pressed
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDark
                          ? const Color(0x0DFFFFFF) // white ~5%
                          : const Color(0x0A10213B), // navyPrimary ~4%
                      isDark
                          ? const Color(0x05FFFFFF)
                          : const Color(0x0510213B),
                    ],
                  )
                : null,
          ),
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            splashColor: isDark
                ? const Color(0x1AFFFFFF) // white ~10%
                : const Color(0x1A10213B), // navyPrimary ~10%
            highlightColor: isDark
                ? const Color(0x0DFFFFFF)
                : const Color(0x0D10213B),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.navyDark
                        : AppColors.silverLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    size: AppDimensions.iconLg - 4,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  widget.label,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Booking Card
// ═══════════════════════════════════════════════════════════════════════════

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isDark;

  const _BookingCard({required this.booking, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Material(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: InkWell(
          onTap: () => context.router.push(JobTrackerRoute(booking: booking)),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          splashColor: isDark
              ? const Color(0x1AFFFFFF)
              : const Color(0x1A10213B),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(
                color: isDark ? AppColors.navyLight : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.sm),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.navyDark
                        : AppColors.silverLight,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Icon(
                    Icons.build_circle_outlined,
                    size: AppDimensions.iconMd,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.service.name,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        '${booking.bookingDate.toLocal().toString().split(' ')[0]} ${booking.bookingTime}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                StatusBadge(status: booking.status.name, compact: true),
                const SizedBox(width: AppDimensions.sm),
                Icon(
                  Icons.chevron_right_rounded,
                  size: AppDimensions.iconSm,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Offer Card
// ===========================================================================

class _OfferCard extends StatelessWidget {
  final PromotionModel offer;
  final bool isDark;

  const _OfferCard({required this.offer, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 280,
      height: 140,
      child: Material(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.navyPrimary,
                  isDark ? AppColors.navyLight : AppColors.navyDark,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        offer.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xCCFFFFFF), // white ~80%
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Learn More →',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
