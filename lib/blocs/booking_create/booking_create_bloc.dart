import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/booking_repository.dart';
import 'booking_create_event.dart';
import 'booking_create_state.dart';

class BookingCreateBloc extends Bloc<BookingCreateEvent, BookingCreateState> {
  final BookingRepository repository;

  BookingCreateBloc(this.repository) : super(BookingCreateInitial()) {
    on<SelectService>((event, emit) {
      emit(ServiceSelected(selectedService: event.service));
    });

    on<SelectDate>((event, emit) {
      emit(DateSelected(
        selectedService: state.selectedService,
        selectedDate: event.date,
        selectedSlot: event.slot,
      ));
    });

    on<ProvideDetails>((event, emit) {
      emit(DetailsProvided(
        selectedService: state.selectedService,
        selectedDate: state.selectedDate,
        selectedSlot: state.selectedSlot,
        photos: event.photos,
        notes: event.notes,
      ));
    });

    on<SubmitBooking>((event, emit) async {
      emit(BookingSubmitting(
        selectedService: state.selectedService,
        selectedDate: state.selectedDate,
        selectedSlot: state.selectedSlot,
        photos: state.photos,
        notes: state.notes,
      ));

      final payload = {
        'service_id': state.selectedService?.id,
        'date': state.selectedDate?.toIso8601String(),
        'time': state.selectedSlot,
        'notes': state.notes,
        'photos': state.photos,
      };

      final result = await repository.createBooking(payload);

      result.when(
        onSuccess: (booking) => emit(BookingSuccess(booking)),
        onFailure: (failure) => emit(BookingFailure(
          failure,
          selectedService: state.selectedService,
          selectedDate: state.selectedDate,
          selectedSlot: state.selectedSlot,
          photos: state.photos,
          notes: state.notes,
        )),
      );
    });
  }
}
