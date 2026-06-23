// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  service: ServiceModel.fromJson(json['service'] as Map<String, dynamic>),
  bookingDate: DateTime.parse(json['bookingDate'] as String),
  bookingTime: json['bookingTime'] as String,
  status: $enumDecode(_$BookingStatusEnumMap, json['status']),
  notes: json['notes'] as String?,
  damagePhotos:
      (json['damagePhotos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  totalAmount: (json['totalAmount'] as num).toDouble(),
  paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
  paymentReference: json['paymentReference'] as String?,
  invoiceUrl: json['invoiceUrl'] as String?,
  adminNotes: json['adminNotes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  scratchCard: json['scratchCard'] == null
      ? null
      : ScratchCardModel.fromJson(json['scratchCard'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'service': instance.service.toJson(),
      'bookingDate': instance.bookingDate.toIso8601String(),
      'bookingTime': instance.bookingTime,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'damagePhotos': instance.damagePhotos,
      'totalAmount': instance.totalAmount,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'paymentReference': instance.paymentReference,
      'invoiceUrl': instance.invoiceUrl,
      'adminNotes': instance.adminNotes,
      'createdAt': instance.createdAt.toIso8601String(),
      'scratchCard': instance.scratchCard?.toJson(),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.in_queue: 'in_queue',
  BookingStatus.being_assessed: 'being_assessed',
  BookingStatus.in_progress: 'in_progress',
  BookingStatus.ready: 'ready',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
};
