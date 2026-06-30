import 'package:equatable/equatable.dart';
import 'dart:io';

sealed class PersonalInfoEvent extends Equatable {
  const PersonalInfoEvent();
  @override
  List<Object?> get props => [];
}

class LoadPersonalInfo extends PersonalInfoEvent {
  const LoadPersonalInfo();
}

class SavePersonalInfo extends PersonalInfoEvent {
  final String name;
  final String email;
  final String phone;
  final File? avatarFile; // null → no change to avatar

  const SavePersonalInfo({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarFile,
  });

  @override
  List<Object?> get props => [name, email, phone, avatarFile];
}
