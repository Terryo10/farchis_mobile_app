import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../../data/models/user_model.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - checking authentication
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// OTP loading state
class OtpLoading extends AuthState {
  final String phone;

  const OtpLoading(this.phone);

  @override
  List<Object?> get props => [phone];
}

/// OTP sent successfully
class OtpSent extends AuthState {
  final String phone;
  final int? expirySeconds;

  const OtpSent(this.phone, {this.expirySeconds});

  @override
  List<Object?> get props => [phone, expirySeconds];
}

/// OTP send failed
class OtpSendFailed extends AuthState {
  final String phone;
  final Failure failure;

  const OtpSendFailed(this.phone, this.failure);

  @override
  List<Object?> get props => [phone, failure];
}

/// Verifying OTP
class OtpVerifying extends AuthState {
  final String phone;

  const OtpVerifying(this.phone);

  @override
  List<Object?> get props => [phone];
}

/// Authenticated state
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// OTP verification failed
class OtpVerificationFailed extends AuthState {
  final Failure failure;

  const OtpVerificationFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}

/// Profile loading state
class ProfileLoading extends AuthState {
  final UserModel currentUser;

  const ProfileLoading(this.currentUser);

  @override
  List<Object?> get props => [currentUser];
}

/// Profile updated
class ProfileUpdated extends AuthState {
  final UserModel user;

  const ProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Profile update failed
class ProfileUpdateFailed extends AuthState {
  final UserModel currentUser;
  final Failure failure;

  const ProfileUpdateFailed(this.currentUser, this.failure);

  @override
  List<Object?> get props => [currentUser, failure];
}

/// Logout loading
class LogoutLoading extends AuthState {
  final UserModel currentUser;

  const LogoutLoading(this.currentUser);

  @override
  List<Object?> get props => [currentUser];
}

/// Logout failed
class LogoutFailed extends AuthState {
  final UserModel currentUser;
  final Failure failure;

  const LogoutFailed(this.currentUser, this.failure);

  @override
  List<Object?> get props => [currentUser, failure];
}

/// Generic auth error
class AuthError extends AuthState {
  final Failure failure;

  const AuthError(this.failure);

  @override
  List<Object?> get props => [failure];
}

/// Google Sign In Loading
class GoogleSignInLoading extends AuthState {
  const GoogleSignInLoading();
}

/// Google Sign In Failed
class GoogleSignInFailed extends AuthState {
  final Failure failure;

  const GoogleSignInFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
