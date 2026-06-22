import 'package:equatable/equatable.dart';
import '../../data/models/service_model.dart';

sealed class BookingCreateEvent extends Equatable {
  const BookingCreateEvent();

  @override
  List<Object?> get props => [];
}

class SelectService extends BookingCreateEvent {
  final ServiceModel service;
  const SelectService(this.service);

  @override
  List<Object?> get props => [service];
}

class SelectDate extends BookingCreateEvent {
  final DateTime date;
  final String slot;

  const SelectDate({required this.date, required this.slot});

  @override
  List<Object?> get props => [date, slot];
}

class ProvideDetails extends BookingCreateEvent {
  final List<String> photos;
  final String notes;

  const ProvideDetails({required this.photos, required this.notes});

  @override
  List<Object?> get props => [photos, notes];
}

class SubmitBooking extends BookingCreateEvent {}
