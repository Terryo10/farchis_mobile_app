import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';
import '../../router/app_router.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Custom gradient header with avatar
              _buildHeader(context, theme, isDark, mediaQuery),

              // Settings sections
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimensions.xxl),

                        // Account section
                        _buildSectionHeader(context, 'Account'),
                        const SizedBox(height: AppDimensions.sm),
                        _buildSettingsGroup(context, theme, isDark, [
                          _SettingsItem(
                            icon: Icons.person_outline_rounded,
                            label: 'Personal Info',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.directions_car_outlined,
                            label: 'My Vehicles',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.payment_rounded,
                            label: 'Payment Methods',
                            onTap: () {},
                          ),
                        ]),

                        const SizedBox(height: AppDimensions.xxl),

                        // Preferences section
                        _buildSectionHeader(context, 'Preferences'),
                        const SizedBox(height: AppDimensions.sm),
                        _buildSettingsGroup(context, theme, isDark, [
                          _SettingsItem(
                            icon: Icons.notifications_outlined,
                            label: 'Notifications',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.dark_mode_outlined,
                            label: 'Dark Mode',
                            trailing: _buildDarkModeSwitch(theme, isDark),
                          ),
                          _SettingsItem(
                            icon: Icons.language_rounded,
                            label: 'Language',
                            subtitle: 'English',
                            onTap: () {},
                          ),
                        ]),

                        const SizedBox(height: AppDimensions.xxl),

                        // Support section
                        _buildSectionHeader(context, 'Support'),
                        const SizedBox(height: AppDimensions.sm),
                        _buildSettingsGroup(context, theme, isDark, [
                          _SettingsItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Help Center',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.star_outline_rounded,
                            label: 'Rate Us',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.shield_outlined,
                            label: 'Privacy Policy',
                            onTap: () {},
                          ),
                        ]),

                        const SizedBox(height: AppDimensions.xxxl),

                        // Logout button
                        Center(
                          child: FarchisButton(
                            label: 'Logout',
                            variant: ButtonVariant.text,
                            icon: Icon(
                              Icons.logout_rounded,
                              size: AppDimensions.iconSm,
                              color: isDark
                                  ? AppColors.darkError
                                  : AppColors.lightError,
                            ),
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(LogoutRequested());
                              context.router
                                  .replaceAll([const LoginRoute()]);
                            },
                          ),
                        ),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    MediaQueryData mediaQuery,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.navyDark,
                  AppColors.navyDarkest,
                ]
              : [
                  AppColors.navyPrimary,
                  AppColors.navyDark,
                ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppDimensions.xl,
            bottom: AppDimensions.xxxl,
          ),
          child: Column(
            children: [
              // Title row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: AppColors.silverDark,
                      ),
                      tooltip: 'Settings',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.xxl),

              // Avatar
              Container(
                width: AppDimensions.avatarXlarge,
                height: AppDimensions.avatarXlarge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.navyLight,
                      AppColors.navyPrimary.withOpacity(0.8),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.tierGold.withOpacity(0.6),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: AppDimensions.iconXl,
                  color: AppColors.silverLight,
                ),
              ),

              const SizedBox(height: AppDimensions.lg),

              // Name
              Text(
                'John Doe',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppDimensions.xs),

              // Email
              Text(
                'john.doe@example.com',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.silverDark,
                ),
              ),

              const SizedBox(height: AppDimensions.md),

              // Loyalty badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg,
                  vertical: AppDimensions.sm,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusCircle,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.tierGold.withOpacity(0.3),
                      AppColors.tierGold.withOpacity(0.15),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.tierGold.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium_rounded,
                      size: AppDimensions.iconSm,
                      color: AppColors.tierGold,
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      'Gold Member',
                      style: theme.textTheme.labelMedium?.copyWith(
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.xs),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    List<_SettingsItem> items,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.black : AppColors.navyDarkest)
                .withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _buildSettingsTile(
                context,
                theme,
                isDark,
                item,
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 56,
                  ),
                  child: Divider(
                    height: AppDimensions.dividerThickness,
                    thickness: AppDimensions.dividerThickness,
                    color: theme.colorScheme.outline.withOpacity(0.15),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    _SettingsItem item,
  ) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md + 2,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(
                    isDark ? 0.15 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSm,
                  ),
                ),
                child: Icon(
                  item.icon,
                  size: AppDimensions.iconSm,
                  color: theme.colorScheme.primary.withOpacity(0.8),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              item.trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    size: AppDimensions.iconMd,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeSwitch(ThemeData theme, bool isDark) {
    return Switch.adaptive(
      value: _darkModeEnabled,
      onChanged: (value) {
        setState(() {
          _darkModeEnabled = value;
        });
      },
      activeColor: isDark ? AppColors.darkInfo : AppColors.lightInfo,
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.trailing,
  });
}
