import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/booking_repository.dart';
import 'booking_create_event.dart';
import 'booking_create_state.dart';

class BookingCreateBloc extends Bloc<BookingCreateEvent, BookingCreateState> {
  final BookingRepository repository;

  BookingCreateBloc(this.repository) : super(BookingCreateInitial()) {
    on<SelectService>((event, emit) {
      emit(ServiceSelected(
        selectedService: event.service,
        selectedVehicle: state.selectedVehicle,
      ));
    });

    on<SelectVehicle>((event, emit) {
      emit(ServiceSelected(
        selectedService: state.selectedService,
        selectedVehicle: event.vehicle,
      ));
    });

    on<SelectDate>((event, emit) {
      emit(DateSelected(
        selectedService: state.selectedService,
        selectedVehicle: state.selectedVehicle,
        selectedDate: event.date,
        selectedSlot: event.slot,
      ));
    });

    on<ProvideDetails>((event, emit) {
      emit(DetailsProvided(
        selectedService: state.selectedService,
        selectedVehicle: state.selectedVehicle,
        selectedDate: state.selectedDate,
        selectedSlot: state.selectedSlot,
        photos: event.photos,
        notes: event.notes,
      ));
    });

    on<SubmitBooking>((event, emit) async {
      emit(BookingSubmitting(
        selectedService: state.selectedService,
        selectedVehicle: state.selectedVehicle,
        selectedDate: state.selectedDate,
        selectedSlot: state.selectedSlot,
        photos: state.photos,
        notes: state.notes,
      ));

      final payload = {
        'service_id': state.selectedService?.id,
        'vehicle_id': state.selectedVehicle?.id,
        'booking_date': state.selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(state.selectedDate!)
            : null,
        'booking_time': state.selectedSlot,
        'notes': state.notes,
      };

      final result = await repository.createBooking(payload);

      result.when(
        onSuccess: (booking) => emit(BookingSuccess(
          booking,
          selectedService: state.selectedService,
          selectedVehicle: state.selectedVehicle,
          selectedDate: state.selectedDate,
          selectedSlot: state.selectedSlot,
          photos: state.photos,
          notes: state.notes,
        )),
        onFailure: (failure) => emit(BookingFailure(
          failure,
          selectedService: state.selectedService,
          selectedVehicle: state.selectedVehicle,
          selectedDate: state.selectedDate,
          selectedSlot: state.selectedSlot,
          photos: state.photos,
          notes: state.notes,
        )),
      );
    });

    on<ResetBookingCreate>((event, emit) => emit(BookingCreateInitial()));
  }
}
