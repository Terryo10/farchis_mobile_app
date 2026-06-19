import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

/// BookingBloc manages the booking list and details
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(const BookingInitial()) {
    on<GetBookingsEvent>(_onGetBookings);
    on<GetBookingEvent>(_onGetBooking);
    on<RefreshBookingEvent>(_onRefreshBooking);
    on<CancelBookingEvent>(_onCancelBooking);
    on<GetAvailableSlotsEvent>(_onGetAvailableSlots);
  }

  Future<void> _onGetBookings(GetBookingsEvent event, Emitter<BookingState> emit) async {
    emit(const BookingsLoading());

    final result = await bookingRepository.getBookings();

    result.when(
      onSuccess: (bookings) {
        emit(BookingsLoaded(bookings));
      },
      onFailure: (failure) {
        emit(BookingsLoadFailed(failure));
      },
    );
  }

  Future<void> _onGetBooking(GetBookingEvent event, Emitter<BookingState> emit) async {
    emit(const BookingDetailLoading());

    final result = await bookingRepository.getBooking(event.id);

    result.when(
      onSuccess: (booking) {
        emit(BookingDetailLoaded(booking));
      },
      onFailure: (failure) {
        emit(BookingDetailLoadFailed(failure));
      },
    );
  }

  Future<void> _onRefreshBooking(RefreshBookingEvent event, Emitter<BookingState> emit) async {
    final result = await bookingRepository.getBooking(event.id);

    result.when(
      onSuccess: (booking) {
        emit(BookingDetailLoaded(booking));
      },
      onFailure: (failure) {
        emit(BookingDetailLoadFailed(failure));
      },
    );
  }

  Future<void> _onCancelBooking(CancelBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingCancelling(event.id));

    final result = await bookingRepository.cancelBooking(event.id);

    result.when(
      onSuccess: (booking) {
        emit(BookingCancelled(booking));
      },
      onFailure: (failure) {
        emit(BookingCancelFailed(failure));
      },
    );
  }

  Future<void> _onGetAvailableSlots(
    GetAvailableSlotsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const SlotsLoading());

    final result = await bookingRepository.getAvailableSlots(
      serviceId: event.serviceId,
      date: event.date,
    );

    result.when(
      onSuccess: (slots) {
        emit(SlotsLoaded(slots));
      },
      onFailure: (failure) {
        emit(SlotsLoadFailed(failure));
      },
    );
  }
}
