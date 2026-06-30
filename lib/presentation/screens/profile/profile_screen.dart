import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/theme/theme_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';
import '../../router/app_router.dart';
import '../../../data/repositories/vehicle_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

    return Scaffold(
      // extendBodyBehindAppBar false (default) so the Scaffold does not render
      // its own top inset — the header's SafeArea handles it.
      // This prevents the status-bar from rendering twice on top of the
      // AutoTabsRouter parent Scaffold which already owns the system overlay.
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
                            onTap: () => context.router.push(const PersonalInfoRoute()),
                          ),
                          _SettingsItem(
                            icon: Icons.directions_car_outlined,
                            label: 'My Vehicles',
                            onTap: () => context.router.push(const MyVehiclesRoute()),
                          ),
                          _SettingsItem(
                            icon: Icons.payment_rounded,
                            label: 'Payment Methods',
                            onTap: () => context.router.push(const PaymentMethodsRoute()),
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
                            onTap: () => context.router.push(const NotificationsRoute()),
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

                        // Support section — Rate Us & Privacy Policy moved
                        // inside HelpSupportScreen to keep nav depth flat.
                        _buildSectionHeader(context, 'Support'),
                        const SizedBox(height: AppDimensions.sm),
                        _buildSettingsGroup(context, theme, isDark, [
                          _SettingsItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Help & Support',
                            onTap: () => context.router.push(const HelpSupportRoute()),
                          ),
                        ]),

                        const SizedBox(height: AppDimensions.xxxl),

                        // Logout button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is Authenticated) {
                              return Center(
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
                              );
                            }
                            return const SizedBox.shrink();
                          },
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
      );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    MediaQueryData mediaQuery,
  ) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
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
          top: true,
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
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    String? avatarUrl = state is Authenticated ? state.user.fullAvatarUrl : null;
                    if (avatarUrl == null || avatarUrl.isEmpty) {
                      try {
                        avatarUrl = GoogleSignIn().currentUser?.photoUrl;
                      } catch (_) {}
                    }
                    return Container(
                      width: AppDimensions.avatarXlarge,
                      height: AppDimensions.avatarXlarge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.navyLight,
                            AppColors.navyPrimary.withValues(alpha: 0.8),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.tierGold.withValues(alpha: 0.6),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.person_rounded,
                                  size: AppDimensions.iconXl,
                                  color: AppColors.silverLight,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.person_rounded,
                              size: AppDimensions.iconXl,
                              color: AppColors.silverLight,
                            ),
                    );
                  },
                ),

                // User Info from AuthBloc
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      final user = state.user;
                      final tierName = user.loyaltyTier != null
                          ? '${user.loyaltyTier!.name.substring(0, 1).toUpperCase()}${user.loyaltyTier!.name.substring(1)} Member'
                          : 'Member';

                      return Column(
                        children: [
                          // Name
                          Text(
                            user.name,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.xs),
                          // Email
                          Text(
                            user.email,
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
                                  AppColors.tierGold.withValues(alpha: 0.3),
                                  AppColors.tierGold.withValues(alpha: 0.15),
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.tierGold.withValues(alpha: 0.5),
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
                                  tierName,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: AppColors.tierGold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is Unauthenticated || state is AuthInitial) {
                      return Column(
                        children: [
                          Text(
                            'Guest',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.md),
                          FarchisButton(
                            label: 'Sign In / Register',
                            onPressed: () {
                              context.router.push(const LoginRoute());
                            },
                          ),
                        ],
                      );
                    }

                    // Fallback / Loading
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
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
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
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
                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
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
                  color: theme.colorScheme.primary.withValues(
                    alpha: isDark ? 0.15 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSm,
                  ),
                ),
                child: Icon(
                  item.icon,
                  size: AppDimensions.iconSm,
                  color: theme.colorScheme.primary.withValues(alpha: 0.8),
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeSwitch(ThemeData theme, bool isDark) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        return Switch.adaptive(
          value: isDarkMode,
          onChanged: (value) {
            context.read<ThemeCubit>().toggleTheme();
          },
          activeColor: isDark ? AppColors.darkInfo : AppColors.lightInfo,
        );
      },
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

class _VehicleManagementForm extends StatefulWidget {
  const _VehicleManagementForm();

  @override
  State<_VehicleManagementForm> createState() => _VehicleManagementFormState();
}

class _VehicleManagementFormState extends State<_VehicleManagementForm> {
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _plateController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final user = authState.user;
      _makeController.text = user.vehicleMake ?? '';
      _modelController.text = user.vehicleModel ?? '';
      _yearController.text = user.vehicleYear?.toString() ?? '';
      _plateController.text = user.vehiclePlate ?? '';
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicle() async {
    final make = _makeController.text.trim();
    final model = _modelController.text.trim();
    final yearStr = _yearController.text.trim();
    final plate = _plateController.text.trim();

    if (make.isEmpty || model.isEmpty || yearStr.isEmpty || plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final year = int.tryParse(yearStr);
    if (year == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid year')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final payload = {
      'vehicle_make': make,
      'vehicle_model': model,
      'vehicle_year': year,
      'vehicle_plate': plate,
    };

    final repository = context.read<VehicleRepository>();
    final result = await repository.updateVehicle(payload);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      result.when(
        onSuccess: (updatedUser) {
          context.read<AuthBloc>().add(AuthUserUpdated(updatedUser));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle details saved successfully')),
          );
          Navigator.pop(context);
        },
        onFailure: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppDimensions.lg,
        right: AppDimensions.lg,
        top: AppDimensions.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Manage Vehicle', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppDimensions.lg),
          TextField(
            controller: _makeController,
            decoration: const InputDecoration(labelText: 'Make', border: OutlineInputBorder()),
          ),
          const SizedBox(height: AppDimensions.md),
          TextField(
            controller: _modelController,
            decoration: const InputDecoration(labelText: 'Model', border: OutlineInputBorder()),
          ),
          const SizedBox(height: AppDimensions.md),
          TextField(
            controller: _yearController,
            decoration: const InputDecoration(labelText: 'Year', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppDimensions.md),
          TextField(
            controller: _plateController,
            decoration: const InputDecoration(labelText: 'Plate', border: OutlineInputBorder()),
          ),
          const SizedBox(height: AppDimensions.xl),
          SizedBox(
            width: double.infinity,
            child: FarchisButton(
              label: 'Save Vehicle',
              isLoading: _isLoading,
              onPressed: _saveVehicle,
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
        ],
      ),
    );
  }
}
