import 'package:json_annotation/json_annotation.dart';
import 'vehicle_model.dart';

part 'inspection_request_model.g.dart';

enum InspectionMode {
  @JsonValue('on_site')
  onSite,
  @JsonValue('in_shop')
  inShop,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum InspectionStatus {
  submitted,
  reviewing,
  quoted,
  accepted,
  declined,
  completed,
  cancelled,
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class InspectionRequestModel {
  final int id;
  final VehicleModel vehicle;
  final InspectionMode inspectionMode;
  final String? address;
  final String preferredDate;
  final String? preferredTime;
  final String description;
  final List<String> photos;
  final InspectionStatus status;
  final double? quoteAmount;
  final String? quoteNotes;
  final int? bookingId;
  final DateTime createdAt;

  const InspectionRequestModel({
    required this.id,
    required this.vehicle,
    required this.inspectionMode,
    this.address,
    required this.preferredDate,
    this.preferredTime,
    required this.description,
    this.photos = const [],
    required this.status,
    this.quoteAmount,
    this.quoteNotes,
    this.bookingId,
    required this.createdAt,
  });

  factory InspectionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$InspectionRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionRequestModelToJson(this);
}
