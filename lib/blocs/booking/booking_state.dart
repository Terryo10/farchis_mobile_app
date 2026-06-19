import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/available_slot_model.dart';

sealed class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingsLoading extends BookingState {
  const BookingsLoading();
}

class BookingsLoaded extends BookingState {
  final List<BookingModel> bookings;

  const BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingsLoadFailed extends BookingState {
  final Failure failure;

  const BookingsLoadFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}

class BookingDetailLoading extends BookingState {
  const BookingDetailLoading();
}

class BookingDetailLoaded extends BookingState {
  final BookingModel booking;

  const BookingDetailLoaded(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingDetailLoadFailed extends BookingState {
  final Failure failure;

  const BookingDetailLoadFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}

class BookingCancelling extends BookingState {
  final String bookingId;

  const BookingCancelling(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class BookingCancelled extends BookingState {
  final BookingModel booking;

  const BookingCancelled(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingCancelFailed extends BookingState {
  final Failure failure;

  const BookingCancelFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}

class SlotsLoading extends BookingState {
  const SlotsLoading();
}

class SlotsLoaded extends BookingState {
  final List<AvailableSlotModel> slots;

  const SlotsLoaded(this.slots);

  @override
  List<Object?> get props => [slots];
}

class SlotsLoadFailed extends BookingState {
  final Failure failure;

  const SlotsLoadFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
