import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../core/error/failures.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/farchis_button.dart';
import '../../core/widgets/farchis_text_field.dart';

/// LoginScreen handles user phone number entry and OTP initiation
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _phoneController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      context.read<AuthBloc>().add(SendOtpEvent(phone));
    }
  }

  String? _validatePhone(String? value) {
    return Validators.validatePhone(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OtpSent) {
              context.push('/otp', extra: {'phone': state.phone});
            } else if (state is OtpSendFailed) {
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
                  // Logo/Header
                  Text(
                    'Farchis',
                    style: AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'Premium Vehicle Maintenance',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.xxxl),
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Enter Your Phone Number',
                          style: AppTextStyles.headlineSmall,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        FarchisTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: '+263712345678',
                          prefixIcon: const Icon(Icons.phone),
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                          enabled: context.watch<AuthBloc>().state is! OtpLoading,
                        ),
                        const SizedBox(height: AppDimensions.xl),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is OtpLoading;
                            return FarchisButton(
                              onPressed: _handleSendOtp,
                              isLoading: isLoading,
                              isEnabled: !isLoading,
                              label: 'Send OTP',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xxxl),
                  // Info Text
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'We\'ll send you a one-time code to verify your phone number',
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.lg),
                        Text(
                          'Your data is secure and encrypted',
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
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
    String message = 'An error occurred. Please try again.';
    if (failure is NetworkFailure) {
      message = 'Network error. Please check your connection.';
    } else if (failure is ServerFailure) {
      message = 'Server error. Please try again later.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
