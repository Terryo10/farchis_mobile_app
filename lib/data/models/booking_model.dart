import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';
import 'service_model.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingModel with _$BookingModel, EquatableMixin {
  const BookingModel._();

  const factory BookingModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'service_id') required String serviceId,
    ServiceModel? service,
    @JsonKey(name: 'booking_date') required String bookingDate,
    @JsonKey(name: 'booking_time') required String bookingTime,
    required String status,
    String? notes,
    @JsonKey(name: 'damage_photos') @Default([]) List<String> damagePhotos,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'payment_reference') String? paymentReference,
    @JsonKey(name: 'invoice_url') String? invoiceUrl,
    @JsonKey(name: 'admin_notes') String? adminNotes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  @override
  List<Object?> get props => [id, userId, status, bookingDate, bookingTime];
}
