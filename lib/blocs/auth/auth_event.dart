import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Send OTP to phone number
class SendOtpEvent extends AuthEvent {
  final String phone;

  const SendOtpEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

/// Verify OTP and authenticate
class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;

  const VerifyOtpEvent({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}

/// Get current user profile
class GetProfileEvent extends AuthEvent {
  const GetProfileEvent();
}

/// Update user profile
class UpdateProfileEvent extends AuthEvent {
  final String name;
  final String? email;
  final String? phone;
  final String? vehicleMake;
  final String? vehicleModel;
  final int? vehicleYear;
  final String? vehiclePlate;

  const UpdateProfileEvent({
    required this.name,
    this.email,
    this.phone,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleYear,
    this.vehiclePlate,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        vehicleMake,
        vehicleModel,
        vehicleYear,
        vehiclePlate,
      ];
}

/// Update FCM token
class UpdateFcmTokenEvent extends AuthEvent {
  final String token;

  const UpdateFcmTokenEvent(this.token);

  @override
  List<Object?> get props => [token];
}

/// Logout user
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Check authentication status
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

/// Sign in with Google
class GoogleSignInEvent extends AuthEvent {
  const GoogleSignInEvent();
}
