import 'package:equatable/equatable.dart';

sealed class InspectionRequestEvent extends Equatable {
  const InspectionRequestEvent();
  @override
  List<Object?> get props => [];
}

class LoadInspectionRequests extends InspectionRequestEvent {
  const LoadInspectionRequests();
}

class LoadInspectionRequestDetail extends InspectionRequestEvent {
  final int id;
  const LoadInspectionRequestDetail(this.id);
  @override
  List<Object?> get props => [id];
}

class CreateInspectionRequest extends InspectionRequestEvent {
  final int vehicleId;
  final String inspectionMode;
  final String? address;
  final String preferredDate;
  final String? preferredTime;
  final String description;
  final List<String> photoPaths;

  const CreateInspectionRequest({
    required this.vehicleId,
    required this.inspectionMode,
    this.address,
    required this.preferredDate,
    this.preferredTime,
    required this.description,
    this.photoPaths = const [],
  });

  @override
  List<Object?> get props =>
      [vehicleId, inspectionMode, address, preferredDate, preferredTime, description, photoPaths];
}

class AcceptInspectionQuote extends InspectionRequestEvent {
  final int id;
  const AcceptInspectionQuote(this.id);
  @override
  List<Object?> get props => [id];
}

class DeclineInspectionRequest extends InspectionRequestEvent {
  final int id;
  final String? reason;
  const DeclineInspectionRequest(this.id, {this.reason});
  @override
  List<Object?> get props => [id, reason];
}
