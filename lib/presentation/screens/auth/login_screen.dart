import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';
import '../../router/app_router.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _brandOpacity;
  late final Animation<Offset> _brandSlide;
  late final Animation<double> _accentOpacity;
  late final Animation<double> _headingOpacity;
  late final Animation<Offset> _headingSlide;
  late final Animation<double> _buttonOpacity;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Staggered intervals for each element
    _brandOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _brandSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
    ));

    _accentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );

    _headingOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    );
    _headingSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
    ));

    _buttonOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    );
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic),
    ));

    _footerOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.router.replace(const MainLayoutRoute());
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: AppColors.darkError,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.navyDark, AppColors.navyDarkest],
              stops: [0.0, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xxl,
              ),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Brand Section ──
                  SlideTransition(
                    position: _brandSlide,
                    child: FadeTransition(
                      opacity: _brandOpacity,
                      child: _BrandSection(),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xxl),

                  // ── Silver Accent Line ──
                  FadeTransition(
                    opacity: _accentOpacity,
                    child: Container(
                      width: 60,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.silverDark.withValues(alpha: 0.0),
                            AppColors.silver.withValues(alpha: 0.7),
                            AppColors.silverDark.withValues(alpha: 0.0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xxl),

                  // ── Welcome Heading ──
                  SlideTransition(
                    position: _headingSlide,
                    child: FadeTransition(
                      opacity: _headingOpacity,
                      child: const _WelcomeSection(),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // ── Google Sign-In Button ──
                  SlideTransition(
                    position: _buttonSlide,
                    child: FadeTransition(
                      opacity: _buttonOpacity,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return _GoogleSignInButton(
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(GoogleSignInRequested());
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xxxl),

                  // ── Register Link ──
                  FadeTransition(
                    opacity: _footerOpacity,
                    child: _RegisterLink(
                      onTap: () {
                        context.router.push(const RegisterRoute());
                      },
                    ),
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Brand Section
// ─────────────────────────────────────────────
class _BrandSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // FARCHIS
        Text(
          'FARCHIS',
          style: GoogleFonts.outfit(
            fontSize: 42,
            fontWeight: FontWeight.w800,
            letterSpacing: 12,
            color: AppColors.silverLight,
            height: 1.1,
          ),
          semanticsLabel: 'Farchis brand name',
        ),
        const SizedBox(height: AppDimensions.sm),
        // AUTOMOTIVE
        Text(
          'AUTOMOTIVE',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 6,
            color: AppColors.silverDark.withValues(alpha: 0.8),
          ),
          semanticsLabel: 'Automotive subtitle',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Welcome Section
// ─────────────────────────────────────────────
class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome Back',
          style: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.silverLight,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          'Sign in to continue to your account',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.silverDark.withValues(alpha: 0.7),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Google Sign-In Button
// ─────────────────────────────────────────────
class _GoogleSignInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _GoogleSignInButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeightLg,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.navyDarkest,
          disabledBackgroundColor: AppColors.silver.withValues(alpha: 0.3),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.xl,
            vertical: AppDimensions.md,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(
                    AppColors.navyDarkest.withValues(alpha: 0.6),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Google "G" icon
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.navyDarkest.withValues(alpha: 0.06),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusXs),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.g_mobiledata_rounded,
                        size: 22,
                        color: AppColors.navyDarkest,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navyDarkest,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Register Link
// ─────────────────────────────────────────────
class _RegisterLink extends StatelessWidget {
  final VoidCallback onTap;

  const _RegisterLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.silverDark.withValues(alpha: 0.6),
              ),
            ),
            Text(
              'Register',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.silverLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
