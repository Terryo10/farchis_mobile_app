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
import '../../../blocs/loyalty/loyalty_bloc.dart';
import '../../../blocs/loyalty/loyalty_event.dart';
import '../../../blocs/loyalty/loyalty_state.dart';
import '../../../blocs/scratch_card/scratch_card_bloc.dart';
import '../../../blocs/scratch_card/scratch_card_event.dart';
import '../../../blocs/scratch_card/scratch_card_state.dart';
import '../../../data/models/scratch_card_model.dart';
import '../../../blocs/my_vehicles/my_vehicles_bloc.dart';
import '../../../blocs/my_vehicles/my_vehicles_event.dart';
import '../../../data/models/vehicle_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  // Carousel state
  final PageController _carouselController = PageController();
  int _carouselPage = 0;

  static const int _cardCount = 5;

  // Fallback promo cards shown when API fails or returns empty
  static const List<_PromoCardData> _fallbackPromos = [
    _PromoCardData(
      title: 'Full Valet',
      subtitle: 'Complete interior & exterior — from \$140',
      gradientStart: Color(0xFF182B49),
      gradientEnd: Color(0xFF0A1321),
    ),
    _PromoCardData(
      title: 'Engine Wash',
      subtitle: 'Professional engine degreasing — from \$15',
      gradientStart: Color(0xFF1A3560),
      gradientEnd: Color(0xFF111F36),
    ),
    _PromoCardData(
      title: 'Quick Wash',
      subtitle: 'Express exterior wash in under 30 min',
      gradientStart: Color(0xFF253971),
      gradientEnd: Color(0xFF182B49),
    ),
  ];

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  void initState() {
    super.initState();

    // Trigger data fetches
    context.read<NotificationBloc>().add(const GetNotificationsEvent());
    context.read<PromotionBloc>().add(const GetPromotionsEvent());

    // Fetch scratch cards on initial load
    final scratchCardState = context.read<ScratchCardBloc>().state;
    if (scratchCardState is ScratchCardInitial) {
      context.read<ScratchCardBloc>().add(const GetScratchCardsEvent());
    }

    // Load vehicles
    context.read<MyVehiclesBloc>().add(const LoadVehicles());

    // Ensure loyalty points are loaded for the header pill
    final loyaltyState = context.read<LoyaltyBloc>().state;
    if (loyaltyState is LoyaltyInitial) {
      context.read<LoyaltyBloc>().add(const GetLoyaltyWalletEvent());
    }

    // Stagger animation for service cards
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
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _carouselController.dispose();
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

                    // --- Promo Carousel ---
                    const SizedBox(height: AppDimensions.xxxl),
                    _buildPromoCarousel(context, theme, isDark),

                    // --- Trust / Heritage Strip ---
                    const SizedBox(height: AppDimensions.xxl),
                    _buildTrustStrip(context, theme, isDark),

                    // --- Recent Bookings ---
                    const SizedBox(height: AppDimensions.xxxl),
                    _buildRecentBookings(context, theme, isDark),

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
                      color: const Color(0xB3FFFFFF),
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
                  // ── Header chips row ──────────────────────────────────
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      final isAuthenticated = authState is Authenticated;
                      final label = isAuthenticated
                          ? authState.user.name
                          : 'Guest — sign in';
                      final vehiclesState = context.watch<MyVehiclesBloc>().state;
                      VehicleModel? primaryVehicle;
                      for (final v in vehiclesState.vehicles) {
                        if (v.isPrimary) {
                          primaryVehicle = v;
                          break;
                        }
                      }
                      primaryVehicle ??= vehiclesState.vehicles.isNotEmpty
                          ? vehiclesState.vehicles.first
                          : null;
                      final vehicleLabel = (isAuthenticated && primaryVehicle != null)
                          ? primaryVehicle.displayName
                          : 'Add Vehicle';

                      String? avatarUrl;
                      if (isAuthenticated) {
                        avatarUrl = authState.user.fullAvatarUrl;
                        if (avatarUrl == null || avatarUrl.isEmpty) {
                          try {
                            avatarUrl = GoogleSignIn().currentUser?.photoUrl;
                          } catch (_) {}
                        }
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        clipBehavior: Clip.none,
                        child: Row(
                          children: [
                            // Name chip
                            GestureDetector(
                              onTap: () =>
                                  context.router.push(const ProfileRoute()),
                              child: _GlassStatusChip(
                                leading: avatarUrl != null
                                    ? ClipOval(
                                        child: Image.network(
                                          avatarUrl,
                                          width: AppDimensions.iconXs,
                                          height: AppDimensions.iconXs,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => const Icon(
                                            Icons.person_outline_rounded,
                                            size: AppDimensions.iconXs,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      )
                                    : null,
                                icon: avatarUrl != null
                                    ? null
                                    : Icons.person_outline_rounded,
                                label: label,
                                brightness: 1.0,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.md),
                            // Vehicle chip
                            GestureDetector(
                              onTap: () =>
                                  context.router.push(const MyVehiclesRoute()),
                              child: _GlassStatusChip(
                                icon: Icons.directions_car_rounded,
                                label: vehicleLabel,
                                brightness: 0.7,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.md),
                            // Loyalty points pill ──────────────────────────
                            _buildLoyaltyPill(context),
                          ],
                        ),
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
            final unreadCount =
                state.notifications.where((n) => !n.isRead).length;

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
                        color: Theme.of(context).colorScheme.error,
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
  // STEP 1: Loyalty Points Pill
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildLoyaltyPill(BuildContext context) {
    return BlocBuilder<LoyaltyBloc, LoyaltyState>(
      builder: (context, state) {
        final isLoading = state is LoyaltyInitial || state is LoyaltyLoading;
        final points = state is LoyaltyLoaded ? state.wallet.balance : 0;
        final label = '$points pts';

        return Skeletonizer(
          enabled: isLoading,
          effect: const ShimmerEffect(
            baseColor: Color(0x33FFFFFF),
            highlightColor: Color(0x55FFFFFF),
          ),
          child: GestureDetector(
            onTap: () {
              // Navigate to Rewards tab (index 2)
              AutoTabsRouter.of(context).setActiveIndex(2);
            },
            child: _GlassStatusChip(
              icon: Icons.stars_rounded,
              label: isLoading ? '--- pts' : label,
              brightness: 0.9,
              accentColor: const Color(0xFFc9a84c), // gold star tint
            ),
          ),
        );
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Services Grid (animated + Material InkWell)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildServicesGrid(BuildContext context) {
    final scratchCardState = context.watch<ScratchCardBloc>().state;
    final myVehiclesState = context.watch<MyVehiclesBloc>().state;

    final isScratchLoading = scratchCardState is ScratchCardInitial || scratchCardState is ScratchCardsLoading;

    List<ScratchCardModel> scratchCards = [];
    if (scratchCardState is ScratchCardsLoaded) {
      scratchCards = scratchCardState.cards;
    }

    final unusedCards = scratchCards.where((c) => !c.isScratched).toList();

    String scratchCardSubtitle = "Check back after your next booking";
    String? scratchCardBadge;

    if (isScratchLoading) {
      scratchCardSubtitle = "You have -- unused card(s)";
      scratchCardBadge = "Win up to \$--";
    } else if (unusedCards.isNotEmpty) {
      scratchCardSubtitle = "You have ${unusedCards.length} unused card${unusedCards.length > 1 ? 's' : ''}";
      final maxCard = unusedCards.reduce((curr, next) => curr.prizeValue > next.prizeValue ? curr : next);
      final valStr = maxCard.prizeType == PrizeType.bonus_points
          ? '${maxCard.prizeValue.toStringAsFixed(0)} pts'
          : '\$${maxCard.prizeValue.toStringAsFixed(0)}';
      scratchCardBadge = "Win up to $valStr";
    }

    String myGarageSubtitle = "Manage your vehicles";
    if (myVehiclesState.vehicles.isNotEmpty) {
      final count = myVehiclesState.vehicles.length;
      myGarageSubtitle = "$count vehicle${count > 1 ? 's' : ''} saved";
    }

    Widget animate(int index, Widget child) {
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
        child: child,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
      child: Skeletonizer(
        enabled: isScratchLoading,
        effect: ShimmerEffect(
          baseColor: const Color(0xFF253971).withValues(alpha: 0.08),
          highlightColor: const Color(0xFF253971).withValues(alpha: 0.15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Featured full-width Card: Book a service
            animate(
              0,
              _HomeServicesCard(
                icon: Icons.build_circle_outlined,
                title: 'Book a service',
                subtitle: 'Engine wash, valet and more',
                isFeatured: true,
                onTap: () => context.router.push(const CreateBookingRoute()),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // 2. Side-by-side cards: Request pickup & My Garage
            Row(
              children: [
                Expanded(
                  child: animate(
                    1,
                    _HomeServicesCard(
                      icon: Icons.local_shipping_outlined,
                      title: 'Request pickup',
                      subtitle: 'We come to you',
                      onTap: () => context.router.push(DriverConvenienceMapRoute()),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: animate(
                    3,
                    _HomeServicesCard(
                      icon: Icons.directions_car_outlined,
                      title: 'My Garage',
                      subtitle: myGarageSubtitle,
                      onTap: () => context.router.push(const MyVehiclesRoute()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            // 3. Scratch Card horizontal card
            animate(
              2,
              _HomeServicesCard(
                icon: Icons.confirmation_num_outlined,
                title: 'Scratch Card',
                subtitle: scratchCardSubtitle,
                isHorizontal: true,
                badgeText: scratchCardBadge,
                onTap: () => context.router.push(const ScratchCardRoute()),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // 4. Vehicle inspection horizontal card
            animate(
              4,
              _HomeServicesCard(
                icon: Icons.fact_check_outlined,
                title: 'Request an Inspection',
                subtitle: 'Panel-beating & damage assessment',
                isHorizontal: true,
                onTap: () => context.router.push(const InspectionRequestListRoute()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 2: Promo Carousel (replaces Special Offers)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildPromoCarousel(
      BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
          child: Text('Featured Services', style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: AppDimensions.md),
        BlocBuilder<PromotionBloc, PromotionState>(
          builder: (context, state) {
            final isLoading =
                state is PromotionLoading || state is PromotionInitial;
            final hasFailed = state is PromotionLoadFailed;
            final isEmpty =
                state is PromotionsLoaded && state.promotions.isEmpty;

            // On failure or empty — show fallback cards (never an error message)
            final useFallback = hasFailed || isEmpty;

            final promotions = (!useFallback && state is PromotionsLoaded)
                ? state.promotions
                : PromotionModel.placeholderList(3);

            final itemCount =
                useFallback ? _fallbackPromos.length : promotions.length;

            return Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor:
                    const Color(0xFF253971).withValues(alpha: 0.08),
                highlightColor:
                    const Color(0xFF253971).withValues(alpha: 0.15),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _carouselController,
                      onPageChanged: (page) {
                        setState(() => _carouselPage = page);
                      },
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (useFallback) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.xxl),
                            child: _FallbackPromoCard(
                              data: _fallbackPromos[index],
                              onTap: () => context.router
                                  .push(const CreateBookingRoute()),
                            ),
                          );
                        }
                        final promo = promotions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.xxl),
                          child: _PromoCard(
                            promotion: promo,
                            onTap: () => context.router
                                .push(const CreateBookingRoute()),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  // Dot indicators
                  if (!isLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(itemCount, (index) {
                        final isActive = _carouselPage == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: isActive ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.navyPrimary
                                : (isDark
                                    ? const Color(0x55FFFFFF)
                                    : AppColors.navyPrimary
                                        .withValues(alpha: 0.25)),
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusCircle),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 4: Trust / Heritage Strip
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildTrustStrip(BuildContext context, ThemeData theme, bool isDark) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.xxl),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.navyPrimary.withValues(alpha: 0.15)
              : AppColors.navyPrimary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isDark
                ? AppColors.navyLight.withValues(alpha: 0.3)
                : AppColors.navyPrimary.withValues(alpha: 0.1),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _TrustChip(
                  icon: Icons.history_edu_rounded,
                  value: '30+',
                  caption: 'Years of Service',
                  isDark: isDark,
                ),
              ),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: isDark
                    ? AppColors.navyLight.withValues(alpha: 0.4)
                    : AppColors.navyPrimary.withValues(alpha: 0.15),
              ),
              Expanded(
                child: _TrustChip(
                  icon: Icons.verified_rounded,
                  value: 'ISO 9001',
                  caption: 'Certified',
                  isDark: isDark,
                ),
              ),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: isDark
                    ? AppColors.navyLight.withValues(alpha: 0.4)
                    : AppColors.navyPrimary.withValues(alpha: 0.15),
              ),
              Expanded(
                child: _TrustChip(
                  icon: Icons.people_rounded,
                  value: '1000+',
                  caption: 'Happy Customers',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
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
                onPressed: () =>
                    context.router.push(const BookingListRoute()),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View All',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isDark
                        ? AppColors.darkAccent
                        : AppColors.lightAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            final isLoading =
                state is BookingLoading || state is BookingInitial;
            if (state is BookingError) {
              return const SizedBox();
            }

            final bookings = state is BookingsLoaded
                ? state.active.take(3).toList()
                : BookingModel.placeholderList(3);

            // STEP 3: Improved empty state with CTA button
            if (state is BookingsLoaded && bookings.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.xxl),
                child: _EmptyBookingsState(isDark: isDark),
              );
            }

            return Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor:
                    const Color(0xFF253971).withValues(alpha: 0.08),
                highlightColor:
                    const Color(0xFF253971).withValues(alpha: 0.15),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.xxl),
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
}

// ═══════════════════════════════════════════════════════════════════════════
// Glassmorphism Status Chip
// ═══════════════════════════════════════════════════════════════════════════

class _GlassStatusChip extends StatelessWidget {
  final Widget? leading;
  final IconData? icon;
  final String label;
  final double brightness;
  final Color? accentColor;

  const _GlassStatusChip({
    this.leading,
    this.icon,
    required this.label,
    required this.brightness,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor =
        brightness >= 1.0 ? AppColors.white : const Color(0xB3FFFFFF);
    final iconColor = accentColor ?? labelColor;

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
            color: const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(color: const Color(0x33FFFFFF)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null)
                leading!
              else if (icon != null)
                Icon(icon, size: AppDimensions.iconXs, color: iconColor),
              if (leading != null || icon != null)
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
// Action Card (Material InkWell + gradient press overlay) — STEP 6 polish
// ═══════════════════════════════════════════════════════════════════════════

class _HomeServicesCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isFeatured;
  final bool isHorizontal;
  final String? badgeText;

  const _HomeServicesCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isFeatured = false,
    this.isHorizontal = false,
    this.badgeText,
  });

  @override
  State<_HomeServicesCard> createState() => _HomeServicesCardState();
}

class _HomeServicesCardState extends State<_HomeServicesCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = theme.cardTheme.color ?? theme.colorScheme.surface;

    final iconBgColor = isDark
        ? AppColors.navyLight.withValues(alpha: 0.18)
        : AppColors.navyPrimary.withValues(alpha: 0.08);

    final iconColor = isDark ? AppColors.silverLight : AppColors.navyPrimary;

    final border = Border.all(
      color: widget.isFeatured
          ? (isDark ? AppColors.navyLight : AppColors.navyPrimary)
          : (isDark ? AppColors.navyLight.withValues(alpha: 0.3) : AppColors.lightBorder),
      width: widget.isFeatured ? 2.0 : 1.0,
    );

    final backgroundColor = widget.isFeatured && !isDark
        ? AppColors.navyPrimary.withValues(alpha: 0.03)
        : cardColor;

    final List<BoxShadow> shadows = _pressed
        ? []
        : [
            BoxShadow(
              color: AppColors.navyPrimary.withValues(
                alpha: widget.isFeatured
                    ? (isDark ? 0.2 : 0.1)
                    : (isDark ? 0.1 : 0.04),
              ),
              blurRadius: widget.isFeatured ? 16 : 8,
              offset: Offset(0, widget.isFeatured ? 6 : 4),
            ),
          ];

    Widget content;

    if (widget.isHorizontal) {
      content = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.md,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: AppDimensions.iconSm,
                color: iconColor,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.silverDark : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.badgeText != null) ...[
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFD4A847),
                      Color(0xFFB8942E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.tierGold.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.badgeText!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ] else ...[
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ],
        ),
      );
    } else if (widget.isFeatured) {
      content = Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: AppDimensions.iconMd,
                color: iconColor,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.silverDark : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.silverDark : AppColors.navyPrimary,
            ),
          ],
        ),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.sm + 2),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: AppDimensions.iconSm + 2,
                color: iconColor,
              ),
            ),
            const Spacer(),
            Text(
              widget.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: isDark ? AppColors.silverDark : AppColors.lightTextSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Semantics(
      button: true,
      label: widget.title,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: widget.isFeatured
              ? 84
              : widget.isHorizontal
                  ? 76
                  : 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: border,
            boxShadow: shadows,
          ),
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            splashColor: isDark
                ? const Color(0x1AFFFFFF)
                : const Color(0x1A10213B),
            highlightColor: isDark
                ? const Color(0x0DFFFFFF)
                : const Color(0x0D10213B),
            child: content,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STEP 3: Improved Empty Bookings State
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyBookingsState extends StatelessWidget {
  final bool isDark;

  const _EmptyBookingsState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.xl,
        vertical: AppDimensions.xxxl,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.navyDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.navyLight : AppColors.lightBorder,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.navyPrimary.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon in a rounded container with navy tint
          Container(
            padding: const EdgeInsets.all(AppDimensions.xl),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.navyPrimary.withValues(alpha: 0.3)
                  : AppColors.navyPrimary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.car_repair_rounded,
              size: 56,
              color: isDark
                  ? AppColors.silverLight
                  : AppColors.navyPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          // Headline
          Text(
            'No bookings yet',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.sm),
          // Subtext
          Text(
            'Book your first service and start earning rewards',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.xxl),
          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  context.router.push(const CreateBookingRoute()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navyPrimary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.md),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLg),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STEP 2: Promo Card (API-backed)
// ═══════════════════════════════════════════════════════════════════════════

class _PromoCard extends StatelessWidget {
  final PromotionModel promotion;
  final VoidCallback onTap;

  const _PromoCard({required this.promotion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        promotion.imageUrl != null && promotion.imageUrl!.isNotEmpty;

    return Material(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background: image or gradient
            if (hasImage)
              Image.network(
                promotion.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _navyGradientBox(),
              )
            else
              _navyGradientBox(),

            // Dark gradient overlay for readability
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.3, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),

            // Text content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    promotion.title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    promotion.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xCCFFFFFF),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navyGradientBox() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyPrimary, AppColors.navyDarkest],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STEP 2: Fallback Promo Card (shown on API failure / empty)
// ═══════════════════════════════════════════════════════════════════════════

class _PromoCardData {
  final String title;
  final String subtitle;
  final Color gradientStart;
  final Color gradientEnd;

  const _PromoCardData({
    required this.title,
    required this.subtitle,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

class _FallbackPromoCard extends StatelessWidget {
  final _PromoCardData data;
  final VoidCallback onTap;

  const _FallbackPromoCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [data.gradientStart, data.gradientEnd],
            ),
          ),
          child: Stack(
            children: [
              // Decorative pattern overlay
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: -40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.03),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppDimensions.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: AppDimensions.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: const Text(
                        'FARCHIS AUTOMOTIVE',
                        style: TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      data.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      data.subtitle,
                      style: const TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Row(
                      children: [
                        const Text(
                          'Book Now',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
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
// STEP 4: Trust Chip (used in heritage strip)
// ═══════════════════════════════════════════════════════════════════════════

class _TrustChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String caption;
  final bool isDark;

  const _TrustChip({
    required this.icon,
    required this.value,
    required this.caption,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconSm,
            color: isDark
                ? AppColors.silverLight
                : AppColors.navyPrimary,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.navyPrimary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            caption,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
