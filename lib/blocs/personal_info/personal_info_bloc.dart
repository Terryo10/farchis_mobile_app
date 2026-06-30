import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import 'personal_info_event.dart';
import 'personal_info_state.dart';

class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  PersonalInfoBloc({
    required this.authRepository,
    required this.authBloc,
  }) : super(const PersonalInfoState()) {
    on<LoadPersonalInfo>(_onLoad);
    on<SavePersonalInfo>(_onSave);
  }

  void _onLoad(LoadPersonalInfo event, Emitter<PersonalInfoState> emit) {
    // Data comes directly from the already-loaded AuthBloc state.
    final authState = authBloc.state;
    if (authState is Authenticated) {
      emit(state.copyWith(
        status: PersonalInfoStatus.loaded,
        user: authState.user,
      ));
    } else {
      emit(state.copyWith(status: PersonalInfoStatus.loading));
    }
  }

  Future<void> _onSave(
      SavePersonalInfo event, Emitter<PersonalInfoState> emit) async {
    emit(state.copyWith(status: PersonalInfoStatus.saving, failure: null));

    final payload = <String, dynamic>{
      'name': event.name,
      'email': event.email,
      'phone': event.phone,
    };

    final result = await authRepository.updateProfile(payload);
    result.when(
      onSuccess: (updatedUser) {
        // Propagate to the shared AuthBloc so the header updates too.
        authBloc.add(AuthUserUpdated(updatedUser));
        emit(state.copyWith(
          status: PersonalInfoStatus.saved,
          user: updatedUser,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          status: PersonalInfoStatus.error,
          failure: failure,
        ));
      },
    );
  }
}
