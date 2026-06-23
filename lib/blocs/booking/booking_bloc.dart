import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/failures.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository.dart';

// Events
sealed class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class LoadBookings extends BookingEvent {}

// States
sealed class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<BookingModel> active;
  final List<BookingModel> past;

  const BookingsLoaded({required this.active, required this.past});

  @override
  List<Object?> get props => [active, past];
}

class BookingError extends BookingState {
  final Failure failure;
  const BookingError(this.failure);

  @override
  List<Object?> get props => [failure];
}

// Bloc
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository) : super(BookingInitial()) {
    on<LoadBookings>(_onLoadBookings);
  }

  Future<void> _onLoadBookings(LoadBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await repository.getBookings();

    result.when(
      onSuccess: (bookings) {
        final active = bookings.where((b) => b.status != BookingStatus.completed && b.status != BookingStatus.cancelled).toList();
        final past = bookings.where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.cancelled).toList();
        emit(BookingsLoaded(active: active, past: past));
      },
      onFailure: (failure) {
        emit(BookingError(failure));
      },
    );
  }
}
