import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/service_model.dart';
import '../../data/models/booking_model.dart';

sealed class BookingCreateState extends Equatable {
  final ServiceModel? selectedService;
  final DateTime? selectedDate;
  final String? selectedSlot;
  final List<String>? photos;
  final String? notes;

  const BookingCreateState({
    this.selectedService,
    this.selectedDate,
    this.selectedSlot,
    this.photos,
    this.notes,
  });

  @override
  List<Object?> get props => [
        selectedService,
        selectedDate,
        selectedSlot,
        photos,
        notes,
      ];
}

class BookingCreateInitial extends BookingCreateState {}

class ServiceSelected extends BookingCreateState {
  const ServiceSelected({required super.selectedService});
}

class DateSelected extends BookingCreateState {
  const DateSelected({
    required super.selectedService,
    required super.selectedDate,
    required super.selectedSlot,
  });
}

class DetailsProvided extends BookingCreateState {
  const DetailsProvided({
    required super.selectedService,
    required super.selectedDate,
    required super.selectedSlot,
    required super.photos,
    required super.notes,
  });
}

class BookingSubmitting extends BookingCreateState {
  const BookingSubmitting({
    required super.selectedService,
    required super.selectedDate,
    required super.selectedSlot,
    required super.photos,
    required super.notes,
  });
}

class BookingSuccess extends BookingCreateState {
  final BookingModel booking;
  const BookingSuccess(this.booking);
}

class BookingFailure extends BookingCreateState {
  final Failure failure;
  const BookingFailure(this.failure, {
    super.selectedService,
    super.selectedDate,
    super.selectedSlot,
    super.photos,
    super.notes,
  });
  
  @override
  List<Object?> get props => [...super.props, failure];
}
