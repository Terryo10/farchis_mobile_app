import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/loyalty/loyalty_bloc.dart';
import '../../../blocs/loyalty/loyalty_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/loyalty/loyalty_event.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/loyalty_wallet_model.dart';
import '../../../data/models/loyalty_transaction_model.dart';


@RoutePage()
class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
    context.read<LoyaltyBloc>().add(const GetLoyaltyWalletEvent());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BlocBuilder<LoyaltyBloc, LoyaltyState>(
        builder: (context, loyaltyState) {
          final isLoading = loyaltyState is LoyaltyLoading || loyaltyState is LoyaltyInitial;
          if (loyaltyState is LoyaltyLoadFailed) {
            return Center(child: Text('Failed to load loyalty data'));
          }

          final wallet = loyaltyState is LoyaltyLoaded
              ? loyaltyState.wallet
              : LoyaltyWalletModel.placeholder();
          final transactions = loyaltyState is LoyaltyLoaded
              ? loyaltyState.transactions
              : LoyaltyTransactionModel.placeholderList(3);

          return Skeletonizer(
            enabled: isLoading,
            effect: ShimmerEffect(
              baseColor: const Color(0xFF253971).withValues(alpha: 0.08),
              highlightColor: const Color(0xFF253971).withValues(alpha: 0.15),
            ),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                UserModel? user;
                if (authState is Authenticated) {
                  user = authState.user;
                } else if (isLoading) {
                  user = const UserModel(
                    id: 0,
                    name: 'John Doe',
                    email: 'johndoe@example.com',
                  );
                }
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, theme, isDark, wallet.tier.name),
                      FadeTransition(
                        opacity: isLoading ? const AlwaysStoppedAnimation(1.0) : _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.lg,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppDimensions.xxl),

                              // Loyalty Card
                              _buildLoyaltyCard(context, theme, isDark, wallet.balance, wallet.tier.name, user?.name ?? 'Member'),

                              const SizedBox(height: AppDimensions.xxl),

                              // Progress to next tier
                              _buildTierProgress(context, theme, isDark, wallet.balance, wallet.tier.name),

                              const SizedBox(height: AppDimensions.xxxl),

                              // Recent Activity
                              Text(
                                'Recent Activity',
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: AppDimensions.md),
                              ..._buildActivityList(context, theme, isDark, transactions),

                              const SizedBox(height: AppDimensions.xxxl),

                              // Rewards section
                              Text(
                                'Redeem Rewards',
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: AppDimensions.md),
                              _buildRewardsSection(context, theme, isDark),

                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark, String tierName) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.navyDark, AppColors.navyDarkest]
              : [AppColors.navyPrimary, AppColors.navyDark],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.xl,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Loyalty Wallet',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: AppDimensions.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tierGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusCircle,
                  ),
                  border: Border.all(
                    color: AppColors.tierGold.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: AppDimensions.iconXs,
                      color: AppColors.tierGold,
                    ),
                    const SizedBox(width: AppDimensions.xs),
                    Text(tierName.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.tierGold,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _buildLoyaltyCard(BuildContext context, ThemeData theme, bool isDark, int points, String tierName, String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xxl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD4A847),
            Color(0xFFC9A84C),
            Color(0xFFB8942E),
            Color(0xFFD4A847),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.tierGold.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FARCHIS',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.workspace_premium_rounded,
                color: AppColors.white.withValues(alpha: 0.9),
                size: AppDimensions.iconLg,
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.xxl),

          // Points
          Text(
            points.toString(),
            style: theme.textTheme.displayLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 42,
              height: 1.0,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'LOYALTY POINTS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: AppDimensions.xxl),

          // Bottom row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tierName.toUpperCase()} MEMBER',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'MEMBER SINCE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Jan 2023',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierProgress(BuildContext context, ThemeData theme, bool isDark, int points, String tierName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress to Platinum',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                '$points / 5,000 pts',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.tierGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 0.49),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusCircle,
                ),
                child: LinearProgressIndicator(
                  value: points / 5000,
                  minHeight: 10,
                  backgroundColor: isDark
                      ? AppColors.navyLight.withValues(alpha: 0.3)
                      : AppColors.silver.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.tierGold,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: AppDimensions.iconXs,
                    color: AppColors.tierGold,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    'Gold',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.tierGold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Platinum',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.tierPlatinum,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Icon(
                    Icons.diamond_rounded,
                    size: AppDimensions.iconXs,
                    color: AppColors.tierPlatinum,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActivityList(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    List<LoyaltyTransactionModel> transactions,
  ) {
    return transactions.asMap().entries.map((entry) {
      final index = entry.key;
      final activity = entry.value;
      final isLast = index == transactions.length - 1;

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 400 + (index * 100)),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(
            bottom: isLast ? 0 : AppDimensions.sm,
          ),
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.categoryMaintenance.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMd,
                  ),
                ),
                child: Icon(
                  Icons.star_rounded,
                  size: AppDimensions.iconSm,
                  color: AppColors.categoryMaintenance,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.description,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity.createdAt.toIso8601String().split('T').first,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                activity.type == LoyaltyTransactionType.earn ? '+${activity.points}' : '-${activity.points}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkSuccess
                      : AppColors.lightSuccess,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildRewardsSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final rewards = [
      _RewardItem(
        icon: Icons.local_car_wash_rounded,
        title: 'Free Car Wash',
        points: '800 pts',
        color: AppColors.categoryDetailing,
      ),
      _RewardItem(
        icon: Icons.percent_rounded,
        title: '20% Off Service',
        points: '1,200 pts',
        color: AppColors.categoryMaintenance,
      ),
      _RewardItem(
        icon: Icons.auto_awesome_rounded,
        title: 'Free Detailing',
        points: '2,000 pts',
        color: AppColors.categoryCustom,
      ),
    ];

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: rewards.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppDimensions.md),
        itemBuilder: (context, index) {
          final reward = rewards[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 100)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusLg,
                ),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isDark ? AppColors.black : AppColors.navyDarkest)
                            .withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: reward.color.withValues(
                        alpha: isDark ? 0.2 : 0.1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      reward.icon,
                      size: AppDimensions.iconMd,
                      color: reward.color,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    reward.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tierGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusCircle,
                      ),
                    ),
                    child: Text(
                      reward.points,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.tierGold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class _RewardItem {
  final IconData icon;
  final String title;
  final String points;
  final Color color;

  const _RewardItem({
    required this.icon,
    required this.title,
    required this.points,
    required this.color,
  });
}
