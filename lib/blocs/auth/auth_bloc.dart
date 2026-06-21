import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../../core/error/failures.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// AuthBloc manages the authentication state and user profile
/// - Handles Google Sign-In flow
/// - Handles OTP send/verify flow
/// - Manages authentication tokens in secure storage
/// - Manages user profile updates
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final DioClient dioClient;
  final FlutterSecureStorage secureStorage;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  AuthBloc({
    required this.authRepository,
    required this.dioClient,
    required this.secureStorage,
  }) : super(const AuthInitial()) {
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UpdateFcmTokenEvent>(_onUpdateFcmToken);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  /// Handle Google Sign In
  Future<void> _onGoogleSignIn(GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(const GoogleSignInLoading());

    try {
      // Force sign out first so the account picker always shows
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account == null) {
        // User cancelled
        emit(const AuthUnauthenticated());
        return;
      }

      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(GoogleSignInFailed(Failure.server('No ID token from Google')));
        return;
      }

      final result = await authRepository.googleSignIn(idToken: idToken);

      await result.when(
        onSuccess: (user) async {
          // Token is assumed to be stored in the response
          await dioClient.setToken('token_${user.id}');
          emit(AuthAuthenticated(user));
        },
        onFailure: (failure) {
          emit(GoogleSignInFailed(failure));
        },
      );
    } catch (e) {
      emit(GoogleSignInFailed(Failure.unknown(e.toString())));
    }
  }

  /// Handle send OTP event
  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpLoading(event.phone));

    final result = await authRepository.sendOtp(phone: event.phone);

    result.when(
      onSuccess: (data) {
        emit(OtpSent(event.phone, expirySeconds: 120));
      },
      onFailure: (failure) {
        emit(OtpSendFailed(event.phone, failure));
      },
    );
  }

  /// Handle verify OTP event
  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpVerifying(event.phone));

    final result = await authRepository.verifyOtp(
      phone: event.phone,
      otp: event.otp,
    );

    await result.when(
      onSuccess: (user) async {
        // In a real implementation, the token would be extracted from the API response
        // and stored in the DioClient. For now, we assume the backend handles this.
        await dioClient.setToken('token_${user.id}');
        emit(AuthAuthenticated(user));
      },
      onFailure: (failure) {
        emit(OtpVerificationFailed(failure));
      },
    );
  }

  /// Handle get profile event
  Future<void> _onGetProfile(GetProfileEvent event, Emitter<AuthState> emit) async {
    // Only fetch profile if we're already authenticated
    if (state is! AuthAuthenticated) {
      return;
    }

    final currentUser = (state as AuthAuthenticated).user;
    emit(ProfileLoading(currentUser));

    final result = await authRepository.getProfile();

    result.when(
      onSuccess: (user) {
        emit(AuthAuthenticated(user));
      },
      onFailure: (failure) {
        emit(ProfileUpdateFailed(currentUser, failure));
      },
    );
  }

  /// Handle update profile event
  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    if (state is! AuthAuthenticated) {
      return;
    }

    final currentUser = (state as AuthAuthenticated).user;
    emit(ProfileLoading(currentUser));

    final result = await authRepository.updateProfile(
      name: event.name,
      email: event.email,
      phone: event.phone,
      vehicleMake: event.vehicleMake,
      vehicleModel: event.vehicleModel,
      vehicleYear: event.vehicleYear,
      vehiclePlate: event.vehiclePlate,
    );

    result.when(
      onSuccess: (user) {
        emit(ProfileUpdated(user));
        emit(AuthAuthenticated(user));
      },
      onFailure: (failure) {
        emit(ProfileUpdateFailed(currentUser, failure));
      },
    );
  }

  /// Handle update FCM token event
  Future<void> _onUpdateFcmToken(UpdateFcmTokenEvent event, Emitter<AuthState> emit) async {
    if (state is! AuthAuthenticated) {
      return;
    }

    final result = await authRepository.updateFcmToken(token: event.token);

    result.when(
      onSuccess: (data) {
        // FCM token updated, no state change needed
      },
      onFailure: (failure) {
        // Log the failure but don't change auth state
      },
    );
  }

  /// Handle logout event
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    if (state is! AuthAuthenticated) {
      emit(const AuthUnauthenticated());
      return;
    }

    final currentUser = (state as AuthAuthenticated).user;
    emit(LogoutLoading(currentUser));

    final result = await authRepository.logout();

    await result.when(
      onSuccess: (data) async {
        await dioClient.clearToken();
        emit(const AuthUnauthenticated());
      },
      onFailure: (failure) {
        emit(LogoutFailed(currentUser, failure));
      },
    );
  }

  /// Handle check auth status event
  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final token = await dioClient.getToken();

    if (token == null) {
      emit(const AuthUnauthenticated());
      return;
    }

    // Token exists, try to get profile
    final result = await authRepository.getProfile();

    result.when(
      onSuccess: (user) {
        emit(AuthAuthenticated(user));
      },
      onFailure: (failure) {
        // Token might be invalid
        emit(const AuthUnauthenticated());
      },
    );
  }
}
