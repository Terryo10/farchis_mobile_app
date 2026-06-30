import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/user_model.dart';

enum PersonalInfoStatus { initial, loading, loaded, saving, saved, error }

class PersonalInfoState extends Equatable {
  final PersonalInfoStatus status;
  final UserModel? user;
  final Failure? failure;

  const PersonalInfoState({
    this.status = PersonalInfoStatus.initial,
    this.user,
    this.failure,
  });

  PersonalInfoState copyWith({
    PersonalInfoStatus? status,
    UserModel? user,
    Failure? failure,
  }) {
    return PersonalInfoState(
      status: status ?? this.status,
      user: user ?? this.user,
      failure: failure ?? this.failure,
    );
  }

  bool get isLoading =>
      status == PersonalInfoStatus.loading || status == PersonalInfoStatus.saving;

  @override
  List<Object?> get props => [status, user, failure];
}
