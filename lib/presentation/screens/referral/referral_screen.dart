import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

@RoutePage()
class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _copyCode() {
    Clipboard.setData(
      const ClipboardData(text: 'FARCHIS-JOHN2024'),
    );
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code copied!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
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
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppDimensions.xxxl),

                      // Illustration
                      _buildIllustration(context, theme, isDark),

                      const SizedBox(height: AppDimensions.xxl),

                      // Explanation text
                      Text(
                        'Share your referral code and earn 500 points for each friend who books their first service!',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppDimensions.xxxl),

                      // Referral code card
                      _buildReferralCodeCard(context, theme, isDark),

                      const SizedBox(height: AppDimensions.xxl),

                      // Share buttons
                      _buildShareButtons(context, theme, isDark),

                      const SizedBox(height: AppDimensions.xxxl),

                      // Stats section
                      _buildStatsSection(context, theme, isDark),

                      const SizedBox(height: 120),
                    ],
                  ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Refer a Friend',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                'Earn rewards for every friend you bring',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.silverDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.navyLight.withOpacity(0.4),
                    AppColors.navyDark.withOpacity(0.6),
                  ]
                : [
                    AppColors.navyPrimary.withOpacity(0.1),
                    AppColors.navyDark.withOpacity(0.08),
                  ],
          ),
          border: Border.all(
            color: (isDark ? AppColors.darkInfo : AppColors.lightInfo)
                .withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.darkInfo : AppColors.lightInfo)
                  .withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          Icons.people_rounded,
          size: 56,
          color: isDark ? AppColors.darkInfo : AppColors.lightInfo,
        ),
      ),
    );
  }

  Widget _buildReferralCodeCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.black : AppColors.navyDarkest)
                .withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Referral Code',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          // Dashed border code container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.lg,
              horizontal: AppDimensions.xl,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusMd,
              ),
              border: Border.all(
                color: (isDark ? AppColors.darkInfo : AppColors.lightInfo)
                    .withOpacity(0.4),
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              color: (isDark ? AppColors.darkInfo : AppColors.lightInfo)
                  .withOpacity(0.06),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'FARCHIS-JOHN2024',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    key: ValueKey(_copied),
                    onPressed: _copyCode,
                    icon: Icon(
                      _copied
                          ? Icons.check_circle_rounded
                          : Icons.copy_rounded,
                      color: _copied
                          ? (isDark
                              ? AppColors.darkSuccess
                              : AppColors.lightSuccess)
                          : (isDark
                              ? AppColors.darkInfo
                              : AppColors.lightInfo),
                    ),
                    tooltip: 'Copy code',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButtons(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final shareOptions = [
      _ShareOption(
        icon: Icons.message_rounded,
        label: 'WhatsApp',
        color: const Color(0xFF25D366),
      ),
      _ShareOption(
        icon: Icons.sms_rounded,
        label: 'SMS',
        color: isDark ? AppColors.darkInfo : AppColors.lightInfo,
      ),
      _ShareOption(
        icon: Icons.email_rounded,
        label: 'Email',
        color: isDark ? AppColors.darkWarning : AppColors.lightWarning,
      ),
      _ShareOption(
        icon: Icons.more_horiz_rounded,
        label: 'More',
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: shareOptions.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 80)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 12 * (1 - value)),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Share via ${option.label}'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: option.color.withOpacity(isDark ? 0.2 : 0.1),
                    border: Border.all(
                      color: option.color.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    option.icon,
                    color: option.color,
                    size: AppDimensions.iconMd,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  option.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final stats = [
      _StatItem(
        label: 'Total Referrals',
        value: '5',
        icon: Icons.people_outline_rounded,
        color: isDark ? AppColors.darkInfo : AppColors.lightInfo,
      ),
      _StatItem(
        label: 'Points Earned',
        value: '2,500',
        icon: Icons.stars_rounded,
        color: AppColors.tierGold,
      ),
      _StatItem(
        label: 'Pending',
        value: '2',
        icon: Icons.hourglass_top_rounded,
        color: isDark ? AppColors.darkWarning : AppColors.lightWarning,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Referrals',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.md),
        Row(
          children: stats.asMap().entries.map((entry) {
            final index = entry.key;
            final stat = entry.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: index > 0 ? AppDimensions.sm : 0,
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration:
                      Duration(milliseconds: 500 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: 0.9 + (0.1 * value),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusLg,
                      ),
                      border: Border.all(
                        color: theme.colorScheme.outline
                            .withOpacity(0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark
                                  ? AppColors.black
                                  : AppColors.navyDarkest)
                              .withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          stat.icon,
                          color: stat.color,
                          size: AppDimensions.iconMd,
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          stat.value,
                          style:
                              theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          stat.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ShareOption {
  final IconData icon;
  final String label;
  final Color color;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
