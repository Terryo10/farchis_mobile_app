import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../blocs/scratch_card/scratch_card_bloc.dart';
import '../../../blocs/scratch_card/scratch_card_event.dart';
import '../../../blocs/scratch_card/scratch_card_state.dart';
import '../../../data/models/scratch_card_model.dart';
import '../../../core/widgets/farchis_button.dart';

@RoutePage()
class ScratchCardScreen extends StatefulWidget {
  const ScratchCardScreen({super.key});

  @override
  State<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  late final AnimationController _shimmerController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();

    // Fetch scratch cards
    context.read<ScratchCardBloc>().add(const GetScratchCardsEvent());
  }

  @override
  void dispose() {
    _animController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  IconData _getPrizeIcon(PrizeType type) {
    switch (type) {
      case PrizeType.discount:
        return Icons.percent_rounded;
      case PrizeType.free_valet:
        return Icons.local_car_wash_rounded;
      case PrizeType.bonus_points:
        return Icons.stars_rounded;
    }
  }

  Color _getPrizeColor(PrizeType type, bool isDark) {
    switch (type) {
      case PrizeType.discount:
        return isDark ? AppColors.darkInfo : AppColors.lightInfo;
      case PrizeType.free_valet:
        return AppColors.categoryDetailing;
      case PrizeType.bonus_points:
        return AppColors.tierGold;
    }
  }

  String _getPrizeTitle(PrizeType type, double value) {
    switch (type) {
      case PrizeType.discount:
        return '${value.toInt()}% Off Next Service';
      case PrizeType.free_valet:
        return 'Free Valet Service';
      case PrizeType.bonus_points:
        return '${value.toInt()} Bonus Points';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<ScratchCardBloc, ScratchCardState>(
      listener: (context, state) {
        if (state is ScratchCardScratchSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogCtx) => _ScratchRewardDialog(
              card: state.card,
              onClaim: () {
                Navigator.pop(dialogCtx);
                context.read<ScratchCardBloc>().add(const GetScratchCardsEvent());
              },
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<ScratchCardBloc, ScratchCardState>(
          builder: (context, state) {
            List<ScratchCardModel> available = [];
            List<ScratchCardModel> history = [];

            if (state is ScratchCardsLoaded) {
              available = state.cards.where((c) => !c.isScratched).toList();
              history = state.cards.where((c) => c.isScratched).toList();
            } else if (state is ScratchCardScratchSuccess) {
              // Keep loading or transitioning state until dialog claimed
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ScratchCardBloc>().add(const GetScratchCardsEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(context, theme, isDark),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppDimensions.xxl),

                            if (state is ScratchCardsLoading)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(AppDimensions.xl),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (state is ScratchCardError)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppDimensions.xl),
                                  child: Column(
                                    children: [
                                      Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
                                      const SizedBox(height: AppDimensions.md),
                                      Text(state.failure.message),
                                      const SizedBox(height: AppDimensions.lg),
                                      FarchisButton(
                                        label: 'Retry',
                                        onPressed: () {
                                          context.read<ScratchCardBloc>().add(const GetScratchCardsEvent());
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else ...[
                              // Scratch Card Display
                              if (available.isNotEmpty)
                                _buildScratchCard(context, theme, isDark, available.first)
                              else
                                _buildNoCardPlaceholder(context, theme, isDark),

                              const SizedBox(height: AppDimensions.lg),

                              // Availability text
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.lg,
                                    vertical: AppDimensions.sm,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (available.isNotEmpty
                                            ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                                            : (isDark ? AppColors.darkInfo : AppColors.lightInfo))
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusCircle,
                                    ),
                                    border: Border.all(
                                      color: (available.isNotEmpty
                                              ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                                              : (isDark ? AppColors.darkInfo : AppColors.lightInfo))
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.confirmation_number_rounded,
                                        size: AppDimensions.iconSm,
                                        color: available.isNotEmpty
                                            ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                                            : (isDark ? AppColors.darkInfo : AppColors.lightInfo),
                                      ),
                                      const SizedBox(width: AppDimensions.sm),
                                      Text(
                                        available.isNotEmpty
                                            ? 'You have ${available.length} scratch card${available.length > 1 ? 's' : ''} available'
                                            : 'No scratch cards available',
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: available.isNotEmpty
                                              ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                                              : (isDark ? AppColors.darkInfo : AppColors.lightInfo),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: AppDimensions.xxxl),

                            // How it works
                            _buildHowItWorks(context, theme, isDark),

                            const SizedBox(height: AppDimensions.xxxl),

                            // Prize History
                            Text(
                              'Prize History',
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: AppDimensions.md),
                            if (history.isNotEmpty)
                              _buildPrizeHistory(context, theme, isDark, history)
                            else
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(AppDimensions.xl),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                  border: Border.all(
                                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'No prizes won yet',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.navyDark,
                  const Color(0xFF1A1005),
                  AppColors.navyDarkest,
                ]
              : [
                  AppColors.navyDark,
                  const Color(0xFF2D1F0A),
                  AppColors.navyPrimary,
                ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scratch & Win',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      'Try your luck and win amazing rewards',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.silverDark,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.tierGold,
                size: AppDimensions.iconLg,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScratchCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    ScratchCardModel card,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GestureDetector(
        onTap: () {
          context.read<ScratchCardBloc>().add(ScratchCardTriggeredEvent(card.id.toString()));
        },
        child: Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.tierGold.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Base gold gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFD4A847),
                        Color(0xFFC9A84C),
                        Color(0xFFE8C95A),
                        Color(0xFFB8942E),
                        Color(0xFFD4A847),
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                ),

                // Pattern overlay
                CustomPaint(
                  painter: _ScratchPatternPainter(),
                ),

                // Shimmer effect
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment(-2 + 4 * _shimmerController.value, -0.3),
                          end: Alignment(-1 + 4 * _shimmerController.value, 0.3),
                          colors: [
                            AppColors.transparent,
                            AppColors.white.withValues(alpha: 0.15),
                            AppColors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Container(
                        color: AppColors.white,
                      ),
                    );
                  },
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: AppDimensions.iconSm,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          Icon(
                            Icons.star_rounded,
                            size: AppDimensions.iconLg,
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          Icon(
                            Icons.auto_awesome,
                            size: AppDimensions.iconSm,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      Text(
                        'Scratch to reveal',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'your reward!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.lg,
                          vertical: AppDimensions.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusCircle,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app_rounded,
                              size: AppDimensions.iconSm,
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: AppDimensions.sm),
                            Text(
                              'Tap to scratch',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Corner sparkles
                Positioned(
                  top: AppDimensions.lg,
                  left: AppDimensions.lg,
                  child: Icon(
                    Icons.auto_awesome,
                    size: AppDimensions.iconXs,
                    color: AppColors.white.withValues(alpha: 0.5),
                  ),
                ),
                Positioned(
                  top: AppDimensions.lg,
                  right: AppDimensions.lg,
                  child: Icon(
                    Icons.auto_awesome,
                    size: AppDimensions.iconXs,
                    color: AppColors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoCardPlaceholder(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: isDark ? AppColors.navyDark : AppColors.silver.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_reset_rounded,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            'No cards available',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'Book a service to receive new cards!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final steps = [
      _StepItem(
        icon: Icons.confirmation_number_outlined,
        title: 'Earn Cards',
        subtitle: 'Complete services to earn scratch cards',
      ),
      _StepItem(
        icon: Icons.touch_app_outlined,
        title: 'Scratch',
        subtitle: 'Scratch to reveal your hidden prize',
      ),
      _StepItem(
        icon: Icons.card_giftcard_rounded,
        title: 'Win Rewards',
        subtitle: 'Redeem your prizes on next visit',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How It Works',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.md),
        Row(
          children: steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: index > 0 ? AppDimensions.sm : 0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMd,
                    ),
                    border: Border.all(
                      color:
                          theme.colorScheme.outline.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.tierGold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          step.icon,
                          size: AppDimensions.iconSm,
                          color: AppColors.tierGold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        step.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        step.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrizeHistory(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    List<ScratchCardModel> prizes,
  ) {
    return Column(
      children: prizes.asMap().entries.map((entry) {
        final index = entry.key;
        final prize = entry.value;
        final isLast = index == prizes.length - 1;

        final title = _getPrizeTitle(prize.prizeType, prize.prizeValue);
        final icon = _getPrizeIcon(prize.prizeType);
        final color = _getPrizeColor(prize.prizeType, isDark);

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
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusMd,
              ),
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
                    color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMd,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: AppDimensions.iconSm,
                    color: color,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Won on ${_formatDate(prize.scratchedAt)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSm,
                    ),
                  ),
                  child: Text(
                    'Active',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ScratchRewardDialog extends StatelessWidget {
  final ScratchCardModel card;
  final VoidCallback onClaim;

  const _ScratchRewardDialog({
    required this.card,
    required this.onClaim,
  });

  IconData _getPrizeIcon(PrizeType type) {
    switch (type) {
      case PrizeType.discount:
        return Icons.percent_rounded;
      case PrizeType.free_valet:
        return Icons.local_car_wash_rounded;
      case PrizeType.bonus_points:
        return Icons.stars_rounded;
    }
  }

  String _getPrizeTitle(PrizeType type, double value) {
    switch (type) {
      case PrizeType.discount:
        return '${value.toInt()}% Off';
      case PrizeType.free_valet:
        return 'Free Valet';
      case PrizeType.bonus_points:
        return '+${value.toInt()} Points';
    }
  }

  String _getPrizeSub(PrizeType type) {
    switch (type) {
      case PrizeType.discount:
        return 'Discount code added to your account!';
      case PrizeType.free_valet:
        return 'Redeemable on your next workshop visit!';
      case PrizeType.bonus_points:
        return 'Loyalty points added to your wallet!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      elevation: 24,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E2640),
              Color(0xFF111728),
            ],
          ),
          border: Border.all(color: AppColors.tierGold.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 48,
              color: AppColors.tierGold,
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              'CONGRATULATIONS!',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.tierGold,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'You Scratched and Won',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xl,
                vertical: AppDimensions.lg,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  Icon(
                    _getPrizeIcon(card.prizeType),
                    size: 48,
                    color: AppColors.tierGold,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    _getPrizeTitle(card.prizeType, card.prizeValue),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    _getPrizeSub(card.prizeType),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
            SizedBox(
              width: double.infinity,
              child: FarchisButton(
                label: 'Claim Reward',
                onPressed: onClaim,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScratchPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width + size.height; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      40,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      30,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StepItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StepItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
