import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../core/error/failures.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/farchis_button.dart';

/// OtpScreen handles OTP verification after phone number submission
class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({required this.phone, super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() {
    final otp = _otpController.text.trim();
    if (otp.length == 6) {
      context.read<AuthBloc>().add(
            VerifyOtpEvent(phone: widget.phone, otp: otp),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go('/home');
            } else if (state is OtpVerificationFailed) {
              _showErrorSnackbar(context, state.failure);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text(
                    'Enter Verification Code',
                    style: AppTextStyles.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'We sent a 6-digit code to ${widget.phone}',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.xxxl),
                  // OTP Input
                  Pinput(
                    controller: _otpController,
                    length: 6,
                    showCursor: true,
                    submittedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: AppTextStyles.headlineSmall,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: AppTextStyles.headlineSmall,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: AppTextStyles.headlineSmall,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xxxl),
                  // Verify Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is OtpVerifying;
                      final isEnabled = _otpController.text.length == 6 && !isLoading;
                      return FarchisButton(
                        onPressed: isEnabled ? _handleVerifyOtp : () {},
                        isLoading: isLoading,
                        isEnabled: isEnabled,
                        label: 'Verify Code',
                      );
                    },
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  // Resend Option
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(SendOtpEvent(widget.phone));
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Didn\'t receive code? ',
                              style: AppTextStyles.bodySmall,
                            ),
                            TextSpan(
                              text: 'Resend',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, Failure failure) {
    String message = 'Verification failed. Please try again.';
    if (failure is NetworkFailure) {
      message = 'Network error. Please check your connection.';
    } else if (failure is ServerFailure) {
      message = 'Invalid code or expired. Please try again.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
