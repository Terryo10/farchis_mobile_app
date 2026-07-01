// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionRequestModel _$InspectionRequestModelFromJson(
  Map<String, dynamic> json,
) => InspectionRequestModel(
  id: (json['id'] as num).toInt(),
  vehicle: VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>),
  inspectionMode: $enumDecode(_$InspectionModeEnumMap, json['inspection_mode']),
  address: json['address'] as String?,
  preferredDate: json['preferred_date'] as String,
  preferredTime: json['preferred_time'] as String?,
  description: json['description'] as String,
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  status: $enumDecode(_$InspectionStatusEnumMap, json['status']),
  quoteAmount: (json['quote_amount'] as num?)?.toDouble(),
  quoteNotes: json['quote_notes'] as String?,
  bookingId: (json['booking_id'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$InspectionRequestModelToJson(
  InspectionRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'vehicle': instance.vehicle.toJson(),
  'inspection_mode': _$InspectionModeEnumMap[instance.inspectionMode]!,
  'address': instance.address,
  'preferred_date': instance.preferredDate,
  'preferred_time': instance.preferredTime,
  'description': instance.description,
  'photos': instance.photos,
  'status': _$InspectionStatusEnumMap[instance.status]!,
  'quote_amount': instance.quoteAmount,
  'quote_notes': instance.quoteNotes,
  'booking_id': instance.bookingId,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$InspectionModeEnumMap = {
  InspectionMode.onSite: 'on_site',
  InspectionMode.inShop: 'in_shop',
};

const _$InspectionStatusEnumMap = {
  InspectionStatus.submitted: 'submitted',
  InspectionStatus.reviewing: 'reviewing',
  InspectionStatus.quoted: 'quoted',
  InspectionStatus.accepted: 'accepted',
  InspectionStatus.declined: 'declined',
  InspectionStatus.completed: 'completed',
  InspectionStatus.cancelled: 'cancelled',
};
