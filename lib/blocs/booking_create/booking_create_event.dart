import 'package:equatable/equatable.dart';
import '../../data/models/service_model.dart';
import '../../data/models/vehicle_model.dart';

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

class SelectVehicle extends BookingCreateEvent {
  final VehicleModel vehicle;
  const SelectVehicle(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
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

/// Resets the flow back to its initial (empty) state, e.g. after a booking
/// has been fully paid for/confirmed and the user leaves the create-booking
/// screen, so a future visit doesn't resume a stale, already-submitted booking.
class ResetBookingCreate extends BookingCreateEvent {}
