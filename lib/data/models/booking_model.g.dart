// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  service: ServiceModel.fromJson(json['service'] as Map<String, dynamic>),
  bookingDate: DateTime.parse(json['booking_date'] as String),
  bookingTime: json['booking_time'] as String,
  status: $enumDecode(_$BookingStatusEnumMap, json['status']),
  notes: json['notes'] as String?,
  damagePhotos:
      (json['damage_photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  totalAmount: (json['total_amount'] as num).toDouble(),
  paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['payment_status']),
  paymentReference: json['payment_reference'] as String?,
  invoiceUrl: json['invoice_url'] as String?,
  adminNotes: json['admin_notes'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  scratchCard: json['scratch_card'] == null
      ? null
      : ScratchCardModel.fromJson(json['scratch_card'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'service': instance.service.toJson(),
      'booking_date': instance.bookingDate.toIso8601String(),
      'booking_time': instance.bookingTime,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'damage_photos': instance.damagePhotos,
      'total_amount': instance.totalAmount,
      'payment_status': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'payment_reference': instance.paymentReference,
      'invoice_url': instance.invoiceUrl,
      'admin_notes': instance.adminNotes,
      'created_at': instance.createdAt.toIso8601String(),
      'scratch_card': instance.scratchCard?.toJson(),
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
