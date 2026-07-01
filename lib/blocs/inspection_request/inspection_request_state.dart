import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/inspection_request_model.dart';

class InspectionRequestState extends Equatable {
  final List<InspectionRequestModel> requests;
  final InspectionRequestModel? selected;
  final bool isLoading;
  final bool isSubmitting;
  final bool createSuccess;
  final int? acceptedBookingId;
  final Failure? failure;

  const InspectionRequestState({
    this.requests = const [],
    this.selected,
    this.isLoading = false,
    this.isSubmitting = false,
    this.createSuccess = false,
    this.acceptedBookingId,
    this.failure,
  });

  InspectionRequestState copyWith({
    List<InspectionRequestModel>? requests,
    InspectionRequestModel? selected,
    bool? isLoading,
    bool? isSubmitting,
    bool? createSuccess,
    int? acceptedBookingId,
    Failure? failure,
  }) {
    return InspectionRequestState(
      requests: requests ?? this.requests,
      selected: selected ?? this.selected,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      createSuccess: createSuccess ?? false,
      acceptedBookingId: acceptedBookingId ?? this.acceptedBookingId,
      failure: failure,
    );
  }

  @override
  List<Object?> get props =>
      [requests, selected, isLoading, isSubmitting, createSuccess, acceptedBookingId, failure];
}
