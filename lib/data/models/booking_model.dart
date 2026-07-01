import 'package:json_annotation/json_annotation.dart';
import 'service_model.dart';
import 'scratch_card_model.dart';
import 'vehicle_model.dart';

part 'booking_model.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum BookingStatus { pending, confirmed, in_queue, being_assessed, in_progress, ready, completed, cancelled }

@JsonEnum(fieldRename: FieldRename.snake)
enum PaymentStatus { pending, paid, failed }

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class BookingModel {
  final int id;
  final int userId;
  final ServiceModel service;
  final VehicleModel? vehicle;
  final DateTime bookingDate;
  final String bookingTime;
  final BookingStatus status;
  final String? notes;
  final List<String> damagePhotos;
  final double? totalAmount;
  final PaymentStatus paymentStatus;
  final String? paymentReference;
  final String? invoiceUrl;
  final String? adminNotes;
  final DateTime createdAt;
  final ScratchCardModel? scratchCard;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.service,
    this.vehicle,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
    this.notes,
    this.damagePhotos = const [],
    this.totalAmount,
    required this.paymentStatus,
    this.paymentReference,
    this.invoiceUrl,
    this.adminNotes,
    required this.createdAt,
    this.scratchCard,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  BookingModel copyWith({
    int? id,
    int? userId,
    ServiceModel? service,
    VehicleModel? vehicle,
    DateTime? bookingDate,
    String? bookingTime,
    BookingStatus? status,
    String? notes,
    List<String>? damagePhotos,
    double? totalAmount,
    PaymentStatus? paymentStatus,
    String? paymentReference,
    String? invoiceUrl,
    String? adminNotes,
    DateTime? createdAt,
    ScratchCardModel? scratchCard,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      service: service ?? this.service,
      vehicle: vehicle ?? this.vehicle,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      damagePhotos: damagePhotos ?? this.damagePhotos,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentReference: paymentReference ?? this.paymentReference,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      adminNotes: adminNotes ?? this.adminNotes,
      createdAt: createdAt ?? this.createdAt,
      scratchCard: scratchCard ?? this.scratchCard,
    );
  }

  factory BookingModel.placeholder() => BookingModel(
        id: 0,
        userId: 0,
        service: ServiceModel.placeholder(),
        bookingDate: DateTime.now(),
        bookingTime: '10:00 AM',
        status: BookingStatus.confirmed,
        notes: 'Loading notes...',
        damagePhotos: const [],
        totalAmount: 120.0,
        paymentStatus: PaymentStatus.pending,
        createdAt: DateTime.now(),
      );

  static List<BookingModel> placeholderList(int count) =>
      List.generate(count, (index) => BookingModel.placeholder().copyWith(id: index));
}
