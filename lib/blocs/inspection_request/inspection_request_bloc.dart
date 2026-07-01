import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/inspection_request_repository.dart';
import 'inspection_request_event.dart';
import 'inspection_request_state.dart';

class InspectionRequestBloc extends Bloc<InspectionRequestEvent, InspectionRequestState> {
  final InspectionRequestRepository repository;

  InspectionRequestBloc({required this.repository}) : super(const InspectionRequestState()) {
    on<LoadInspectionRequests>(_onLoad);
    on<LoadInspectionRequestDetail>(_onLoadDetail);
    on<CreateInspectionRequest>(_onCreate);
    on<AcceptInspectionQuote>(_onAccept);
    on<DeclineInspectionRequest>(_onDecline);
  }

  Future<void> _onLoad(LoadInspectionRequests event, Emitter<InspectionRequestState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await repository.getInspectionRequests();
    result.when(
      onSuccess: (requests) => emit(state.copyWith(requests: requests, isLoading: false)),
      onFailure: (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
    );
  }

  Future<void> _onLoadDetail(
      LoadInspectionRequestDetail event, Emitter<InspectionRequestState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await repository.getInspectionRequest(event.id);
    result.when(
      onSuccess: (request) => emit(state.copyWith(selected: request, isLoading: false)),
      onFailure: (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
    );
  }

  Future<void> _onCreate(
      CreateInspectionRequest event, Emitter<InspectionRequestState> emit) async {
    emit(state.copyWith(isSubmitting: true, failure: null, createSuccess: false));
    final result = await repository.createInspectionRequest(
      vehicleId: event.vehicleId,
      inspectionMode: event.inspectionMode,
      address: event.address,
      preferredDate: event.preferredDate,
      preferredTime: event.preferredTime,
      description: event.description,
      photoPaths: event.photoPaths,
    );
    result.when(
      onSuccess: (request) {
        final updated = List.of(state.requests)..insert(0, request);
        emit(state.copyWith(requests: updated, isSubmitting: false, createSuccess: true));
      },
      onFailure: (failure) => emit(state.copyWith(isSubmitting: false, failure: failure)),
    );
  }

  Future<void> _onAccept(AcceptInspectionQuote event, Emitter<InspectionRequestState> emit) async {
    emit(state.copyWith(isSubmitting: true, failure: null));
    final result = await repository.acceptQuote(event.id);
    result.when(
      onSuccess: (bookingId) async {
        final detail = await repository.getInspectionRequest(event.id);
        detail.when(
          onSuccess: (request) => emit(state.copyWith(
            selected: request,
            isSubmitting: false,
            acceptedBookingId: bookingId,
          )),
          onFailure: (_) => emit(state.copyWith(isSubmitting: false, acceptedBookingId: bookingId)),
        );
      },
      onFailure: (failure) => emit(state.copyWith(isSubmitting: false, failure: failure)),
    );
  }

  Future<void> _onDecline(
      DeclineInspectionRequest event, Emitter<InspectionRequestState> emit) async {
    emit(state.copyWith(isSubmitting: true, failure: null));
    final result = await repository.decline(event.id, reason: event.reason);
    result.when(
      onSuccess: (request) {
        final updated = state.requests.map((r) => r.id == request.id ? request : r).toList();
        emit(state.copyWith(requests: updated, selected: request, isSubmitting: false));
      },
      onFailure: (failure) => emit(state.copyWith(isSubmitting: false, failure: failure)),
    );
  }
}
