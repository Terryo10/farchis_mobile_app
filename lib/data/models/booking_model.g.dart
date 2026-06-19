// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String,
      service: json['service'] == null
          ? null
          : ServiceModel.fromJson(json['service'] as Map<String, dynamic>),
      bookingDate: json['booking_date'] as String,
      bookingTime: json['booking_time'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      damagePhotos:
          (json['damage_photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentStatus: json['payment_status'] as String?,
      paymentReference: json['payment_reference'] as String?,
      invoiceUrl: json['invoice_url'] as String?,
      adminNotes: json['admin_notes'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'service_id': instance.serviceId,
      'service': instance.service,
      'booking_date': instance.bookingDate,
      'booking_time': instance.bookingTime,
      'status': instance.status,
      'notes': instance.notes,
      'damage_photos': instance.damagePhotos,
      'total_amount': instance.totalAmount,
      'payment_status': instance.paymentStatus,
      'payment_reference': instance.paymentReference,
      'invoice_url': instance.invoiceUrl,
      'admin_notes': instance.adminNotes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
