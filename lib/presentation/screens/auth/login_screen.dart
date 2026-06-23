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

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
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
                backgroundColor: AppColors.lightError,
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
              colors: [AppColors.silverLight, AppColors.white],
              stops: [0.0, 1.0],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
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

                  // ── Navy Accent Line ──
                  FadeTransition(
                    opacity: _accentOpacity,
                    child: Container(
                      width: 60,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.navyLight.withValues(alpha: 0.0),
                            AppColors.navyPrimary.withValues(alpha: 0.5),
                            AppColors.navyLight.withValues(alpha: 0.0),
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

                  // ── Email Login Form ──
                  SlideTransition(
                    position: _buttonSlide,
                    child: FadeTransition(
                      opacity: _buttonOpacity,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return _LoginForm(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            isLoading: state is AuthLoading,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  // ── OR Separator ──
                  SlideTransition(
                    position: _buttonSlide,
                    child: FadeTransition(
                      opacity: _buttonOpacity,
                      child: Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                            child: Text(
                              'OR',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xl),

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
                );
              },
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
        Image.asset(
          'assets/images/logo.png',
          height: 160,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Column(
              children: [
                Text(
                  'FARCHIS',
                  style: GoogleFonts.outfit(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 12,
                    color: AppColors.navyPrimary,
                    height: 1.1,
                  ),
                  semanticsLabel: 'Farchis brand name',
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'AUTOMOTIVE CENTER',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 4,
                    color: AppColors.navyDark.withValues(alpha: 0.8),
                  ),
                  semanticsLabel: 'Automotive subtitle',
                ),
              ],
            );
          },
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
            color: AppColors.navyDarkest,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          'Sign in to continue to your account',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Email Login Form
// ─────────────────────────────────────────────
class _LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;

  const _LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.navyPrimary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: AppColors.navyPrimary.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: AppColors.navyPrimary.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(color: AppColors.navyPrimary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.navyPrimary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: AppColors.navyPrimary.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: AppColors.navyPrimary.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(color: AppColors.navyPrimary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        SizedBox(
          width: double.infinity,
          child: FarchisButton(
            label: 'Sign In',
            isLoading: isLoading,
            onPressed: () {
              final email = emailController.text.trim();
              final password = passwordController.text;
              if (email.isNotEmpty && password.isNotEmpty) {
                context.read<AuthBloc>().add(
                      LoginRequested(email: email, password: password),
                    );
              }
            },
          ),
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
          foregroundColor: AppColors.navyPrimary,
          disabledBackgroundColor: AppColors.white.withValues(alpha: 0.5),
          side: BorderSide(color: AppColors.navyPrimary.withValues(alpha: 0.2)),
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
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(
                    AppColors.white,
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
                      color: AppColors.navyPrimary.withValues(alpha: 0.05),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusXs),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.g_mobiledata_rounded,
                        size: 22,
                        color: AppColors.navyPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navyPrimary,
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
                color: AppColors.lightTextSecondary,
              ),
            ),
            Text(
              'Register',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.navyPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
