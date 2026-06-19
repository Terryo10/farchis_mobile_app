import 'package:equatable/equatable.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class GetBookingsEvent extends BookingEvent {
  const GetBookingsEvent();
}

class GetBookingEvent extends BookingEvent {
  final String id;

  const GetBookingEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshBookingEvent extends BookingEvent {
  final String id;

  const RefreshBookingEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CancelBookingEvent extends BookingEvent {
  final String id;

  const CancelBookingEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetAvailableSlotsEvent extends BookingEvent {
  final String serviceId;
  final String date;

  const GetAvailableSlotsEvent({
    required this.serviceId,
    required this.date,
  });

  @override
  List<Object?> get props => [serviceId, date];
}
