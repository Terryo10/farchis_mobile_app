import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/error/failures.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final FlutterSecureStorage secureStorage;

  AuthBloc({
    required this.authRepository,
    required this.secureStorage,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<UpdateFcmTokenEvent>(_onUpdateFcmTokenEvent);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  void _onAuthUserUpdated(AuthUserUpdated event, Emitter<AuthState> emit) {
    emit(Authenticated(event.user));
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token != null) {
      final result = await authRepository.getMe();
      result.when(
        onSuccess: (user) => emit(Authenticated(user)),
        onFailure: (failure) {
          secureStorage.delete(key: 'auth_token');
          emit(Unauthenticated());
        },
      );
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.login(event.email, event.password);
    result.when(
      onSuccess: (user) => emit(Authenticated(user)),
      onFailure: (failure) => emit(AuthFailure(failure)),
    );
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.register(
      event.name,
      event.email,
      event.password,
      event.phone,
    );
    result.when(
      onSuccess: (user) => emit(Authenticated(user)),
      onFailure: (failure) => emit(AuthFailure(failure)),
    );
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final googleSignIn = GoogleSignIn(
        clientId: '601498933164-h445r9l8f82vq35hie26plki6n061qk1.apps.googleusercontent.com',
        // Web Client ID required to get the id_token on Android
        serverClientId: '601498933164-svtu2ol1nt1uvficg0ljuclk80jtbsof.apps.googleusercontent.com',
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(Unauthenticated());
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(Unauthenticated());
        return;
      }

      final result = await authRepository.googleSignIn(idToken);
      result.when(
        onSuccess: (user) => emit(Authenticated(user)),
        onFailure: (failure) => emit(AuthFailure(failure)),
      );
    } catch (e) {
      emit(AuthFailure(Failure.unknown(e.toString())));
    }
  }

  Future<void> _onUpdateFcmTokenEvent(
      UpdateFcmTokenEvent event, Emitter<AuthState> emit) async {
    // Only send the token to the server if the user is authenticated.
    if (state is Authenticated) {
      // In a real scenario, this might call a specific endpoint or be included in authMe updates.
      // E.g. authRepository.updateFcmToken(event.token)
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await secureStorage.delete(key: 'auth_token');
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    emit(Unauthenticated());
  }
}
