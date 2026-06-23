import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

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
  }

  @override
  void dispose() {
    _animController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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

                    // Scratch Card
                    _buildScratchCard(context, theme, isDark),

                    const SizedBox(height: AppDimensions.lg),

                    // Availability text
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.lg,
                          vertical: AppDimensions.sm,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (isDark
                                      ? AppColors.darkSuccess
                                      : AppColors.lightSuccess)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusCircle,
                          ),
                          border: Border.all(
                            color:
                                (isDark
                                        ? AppColors.darkSuccess
                                        : AppColors.lightSuccess)
                                    .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.confirmation_number_rounded,
                              size: AppDimensions.iconSm,
                              color: isDark
                                  ? AppColors.darkSuccess
                                  : AppColors.lightSuccess,
                            ),
                            const SizedBox(width: AppDimensions.sm),
                            Text(
                              'You have 1 scratch card available',
                              style:
                                  theme.textTheme.labelMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkSuccess
                                    : AppColors.lightSuccess,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

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
                    _buildPrizeHistory(context, theme, isDark),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Scratch card coming soon!'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
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
                // Base gradient
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
                      // Stars decoration
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
                              style:
                                  theme.textTheme.labelMedium?.copyWith(
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
                Positioned(
                  bottom: AppDimensions.lg,
                  left: AppDimensions.lg,
                  child: Icon(
                    Icons.auto_awesome,
                    size: AppDimensions.iconXs,
                    color: AppColors.white.withValues(alpha: 0.4),
                  ),
                ),
                Positioned(
                  bottom: AppDimensions.lg,
                  right: AppDimensions.lg,
                  child: Icon(
                    Icons.auto_awesome,
                    size: AppDimensions.iconXs,
                    color: AppColors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
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
  ) {
    final prizes = [
      _PrizeItem(
        title: '10% Off Next Service',
        date: 'Jun 15, 2026',
        icon: Icons.percent_rounded,
        color: isDark ? AppColors.darkInfo : AppColors.lightInfo,
        isUsed: false,
      ),
      _PrizeItem(
        title: 'Free Car Wash',
        date: 'May 28, 2026',
        icon: Icons.local_car_wash_rounded,
        color: AppColors.categoryDetailing,
        isUsed: true,
      ),
      _PrizeItem(
        title: '500 Bonus Points',
        date: 'May 10, 2026',
        icon: Icons.stars_rounded,
        color: AppColors.tierGold,
        isUsed: true,
      ),
    ];

    return Column(
      children: prizes.asMap().entries.map((entry) {
        final index = entry.key;
        final prize = entry.value;
        final isLast = index == prizes.length - 1;

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
                    color: prize.color.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMd,
                    ),
                  ),
                  child: Icon(
                    prize.icon,
                    size: AppDimensions.iconSm,
                    color: prize.color,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prize.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Won on ${prize.date}',
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
                    color: prize.isUsed
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.08)
                        : (isDark
                                ? AppColors.darkSuccess
                                : AppColors.lightSuccess)
                            .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSm,
                    ),
                  ),
                  child: Text(
                    prize.isUsed ? 'Used' : 'Active',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: prize.isUsed
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          : (isDark
                              ? AppColors.darkSuccess
                              : AppColors.lightSuccess),
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

class _ScratchPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw subtle diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Draw subtle circles
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

class _PrizeItem {
  final String title;
  final String date;
  final IconData icon;
  final Color color;
  final bool isUsed;

  const _PrizeItem({
    required this.title,
    required this.date,
    required this.icon,
    required this.color,
    required this.isUsed,
  });
}
