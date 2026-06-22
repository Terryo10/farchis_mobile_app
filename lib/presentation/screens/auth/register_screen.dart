import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/farchis_button.dart';
import '../../../core/widgets/farchis_text_field.dart';
import '../../router/app_router.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _agreedToTerms = false;

  late final AnimationController _controller;
  late final Animation<double> _brandOpacity;
  late final Animation<double> _headingOpacity;
  late final Animation<Offset> _headingSlide;
  late final Animation<double> _field1Opacity;
  late final Animation<double> _field2Opacity;
  late final Animation<double> _field3Opacity;
  late final Animation<double> _bottomOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _brandOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );

    _headingOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.35, curve: Curves.easeOut),
    );
    _headingSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.35, curve: Curves.easeOutCubic),
    ));

    _field1Opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.5, curve: Curves.easeOut),
    );
    _field2Opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.6, curve: Curves.easeOut),
    );
    _field3Opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.7, curve: Curves.easeOut),
    );

    _bottomOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please accept the Terms & Conditions'),
            backgroundColor: AppColors.darkError,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
          ),
        );
        return;
      }
      // TODO: Wire up to AuthBloc when ready
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dark-themed InputDecorationTheme override for this screen
    final darkInputTheme = InputDecorationTheme(
      filled: true,
      fillColor: AppColors.navyPrimary.withValues(alpha: 0.5),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.silverDark.withValues(alpha: 0.5),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.silverDark,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(
          color: AppColors.navyLight.withValues(alpha: 0.4),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(
          color: AppColors.navyLight.withValues(alpha: 0.4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(
          color: AppColors.silverDark,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(
          color: AppColors.darkError,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(
          color: AppColors.darkError,
          width: 1.5,
        ),
      ),
      prefixIconColor: AppColors.silverDark.withValues(alpha: 0.7),
    );

    return Scaffold(
      body: Container(
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.xxl,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.xxxl),

                    // ── Back Button ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FadeTransition(
                        opacity: _brandOpacity,
                        child: GestureDetector(
                          onTap: () => context.router.maybePop(),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.all(AppDimensions.xs),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color:
                                  AppColors.silverDark.withValues(alpha: 0.8),
                              size: AppDimensions.iconSm,
                              semanticLabel: 'Go back',
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xl),

                    // ── Brand ──
                    FadeTransition(
                      opacity: _brandOpacity,
                      child: Text(
                        'FARCHIS',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 8,
                          color: AppColors.silverLight,
                        ),
                        semanticsLabel: 'Farchis',
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xxxl),

                    // ── Heading ──
                    SlideTransition(
                      position: _headingSlide,
                      child: FadeTransition(
                        opacity: _headingOpacity,
                        child: Column(
                          children: [
                            Text(
                              'Create Account',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.silverLight,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            Text(
                              'Fill in your details to get started',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.silverDark
                                    .withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xxxl + 8),

                    // ── Form Fields ──
                    Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: darkInputTheme,
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: AppColors.silverLight,
                          selectionColor:
                              AppColors.silverDark.withValues(alpha: 0.3),
                          selectionHandleColor: AppColors.silver,
                        ),
                      ),
                      child: DefaultTextStyle(
                        style: GoogleFonts.inter(
                          color: AppColors.silverLight,
                          fontSize: 14,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Full Name
                              FadeTransition(
                                opacity: _field1Opacity,
                                child: FarchisTextField(
                                  controller: _nameController,
                                  label: 'Full Name',
                                  hint: 'Enter your full name',
                                  textCapitalization:
                                      TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: const Icon(
                                    Icons.person_outline_rounded,
                                    size: AppDimensions.iconSm,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(height: AppDimensions.lg),

                              // Email
                              FadeTransition(
                                opacity: _field2Opacity,
                                child: FarchisTextField(
                                  controller: _emailController,
                                  label: 'Email Address',
                                  hint: 'you@example.com',
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    size: AppDimensions.iconSm,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                        .hasMatch(value.trim())) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(height: AppDimensions.lg),

                              // Phone
                              FadeTransition(
                                opacity: _field3Opacity,
                                child: FarchisTextField(
                                  controller: _phoneController,
                                  label: 'Phone Number',
                                  hint: '+263 77 123 4567',
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  prefixIcon: const Icon(
                                    Icons.phone_outlined,
                                    size: AppDimensions.iconSm,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xl),

                    // ── Terms & Conditions ──
                    FadeTransition(
                      opacity: _bottomOpacity,
                      child: _TermsCheckbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() => _agreedToTerms = value ?? false);
                        },
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xxl),

                    // ── Create Account Button ──
                    FadeTransition(
                      opacity: _bottomOpacity,
                      child: SizedBox(
                        width: double.infinity,
                        child: FarchisButton(
                          label: 'Create Account',
                          variant: ButtonVariant.primary,
                          size: ButtonSize.large,
                          width: double.infinity,
                          onPressed: _onCreateAccount,
                        ),
                      ),
                    ),

                    const Spacer(),

                    const SizedBox(height: AppDimensions.xxxl),

                    // ── Sign In Link ──
                    FadeTransition(
                      opacity: _bottomOpacity,
                      child: _SignInLink(
                        onTap: () {
                          context.router.maybePop();
                        },
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xxl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Terms & Conditions Checkbox
// ─────────────────────────────────────────────
class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _TermsCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: value
                    ? AppColors.silverLight
                    : AppColors.transparent,
                border: Border.all(
                  color: value
                      ? AppColors.silverLight
                      : AppColors.silverDark.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
              child: value
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: AppColors.navyDarkest,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'I agree to the ',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.silverDark.withValues(alpha: 0.7),
                ),
                children: [
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.silverLight,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.silverLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sign In Link
// ─────────────────────────────────────────────
class _SignInLink extends StatelessWidget {
  final VoidCallback onTap;

  const _SignInLink({required this.onTap});

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
              'Already have an account? ',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.silverDark.withValues(alpha: 0.6),
              ),
            ),
            Text(
              'Sign In',
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
