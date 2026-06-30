import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String? referralCode;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.referralCode,
  });

  @override
  List<Object?> get props => [name, email, password, phone, referralCode];
}

class GoogleSignInRequested extends AuthEvent {}

class UpdateFcmTokenEvent extends AuthEvent {
  final String token;
  const UpdateFcmTokenEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

class LogoutRequested extends AuthEvent {}

class AuthUserUpdated extends AuthEvent {
  final UserModel user;
  const AuthUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}
