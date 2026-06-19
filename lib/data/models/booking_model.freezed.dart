// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_id')
  String get serviceId => throw _privateConstructorUsedError;
  ServiceModel? get service => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_date')
  String get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_time')
  String get bookingTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'damage_photos')
  List<String> get damagePhotos => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String? get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_reference')
  String? get paymentReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_url')
  String? get invoiceUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin_notes')
  String? get adminNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
    BookingModel value,
    $Res Function(BookingModel) then,
  ) = _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'service_id') String serviceId,
    ServiceModel? service,
    @JsonKey(name: 'booking_date') String bookingDate,
    @JsonKey(name: 'booking_time') String bookingTime,
    String status,
    String? notes,
    @JsonKey(name: 'damage_photos') List<String> damagePhotos,
    @JsonKey(name: 'total_amount') double totalAmount,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'payment_reference') String? paymentReference,
    @JsonKey(name: 'invoice_url') String? invoiceUrl,
    @JsonKey(name: 'admin_notes') String? adminNotes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });

  $ServiceModelCopyWith<$Res>? get service;
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? serviceId = null,
    Object? service = freezed,
    Object? bookingDate = null,
    Object? bookingTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? damagePhotos = null,
    Object? totalAmount = null,
    Object? paymentStatus = freezed,
    Object? paymentReference = freezed,
    Object? invoiceUrl = freezed,
    Object? adminNotes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            serviceId: null == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            service: freezed == service
                ? _value.service
                : service // ignore: cast_nullable_to_non_nullable
                      as ServiceModel?,
            bookingDate: null == bookingDate
                ? _value.bookingDate
                : bookingDate // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingTime: null == bookingTime
                ? _value.bookingTime
                : bookingTime // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            damagePhotos: null == damagePhotos
                ? _value.damagePhotos
                : damagePhotos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentStatus: freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentReference: freezed == paymentReference
                ? _value.paymentReference
                : paymentReference // ignore: cast_nullable_to_non_nullable
                      as String?,
            invoiceUrl: freezed == invoiceUrl
                ? _value.invoiceUrl
                : invoiceUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            adminNotes: freezed == adminNotes
                ? _value.adminNotes
                : adminNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServiceModelCopyWith<$Res>? get service {
    if (_value.service == null) {
      return null;
    }

    return $ServiceModelCopyWith<$Res>(_value.service!, (value) {
      return _then(_value.copyWith(service: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
    _$BookingModelImpl value,
    $Res Function(_$BookingModelImpl) then,
  ) = __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'service_id') String serviceId,
    ServiceModel? service,
    @JsonKey(name: 'booking_date') String bookingDate,
    @JsonKey(name: 'booking_time') String bookingTime,
    String status,
    String? notes,
    @JsonKey(name: 'damage_photos') List<String> damagePhotos,
    @JsonKey(name: 'total_amount') double totalAmount,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'payment_reference') String? paymentReference,
    @JsonKey(name: 'invoice_url') String? invoiceUrl,
    @JsonKey(name: 'admin_notes') String? adminNotes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });

  @override
  $ServiceModelCopyWith<$Res>? get service;
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
    _$BookingModelImpl _value,
    $Res Function(_$BookingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? serviceId = null,
    Object? service = freezed,
    Object? bookingDate = null,
    Object? bookingTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? damagePhotos = null,
    Object? totalAmount = null,
    Object? paymentStatus = freezed,
    Object? paymentReference = freezed,
    Object? invoiceUrl = freezed,
    Object? adminNotes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$BookingModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceId: null == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        service: freezed == service
            ? _value.service
            : service // ignore: cast_nullable_to_non_nullable
                  as ServiceModel?,
        bookingDate: null == bookingDate
            ? _value.bookingDate
            : bookingDate // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingTime: null == bookingTime
            ? _value.bookingTime
            : bookingTime // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        damagePhotos: null == damagePhotos
            ? _value._damagePhotos
            : damagePhotos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentStatus: freezed == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentReference: freezed == paymentReference
            ? _value.paymentReference
            : paymentReference // ignore: cast_nullable_to_non_nullable
                  as String?,
        invoiceUrl: freezed == invoiceUrl
            ? _value.invoiceUrl
            : invoiceUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        adminNotes: freezed == adminNotes
            ? _value.adminNotes
            : adminNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingModelImpl extends _BookingModel {
  const _$BookingModelImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'service_id') required this.serviceId,
    this.service,
    @JsonKey(name: 'booking_date') required this.bookingDate,
    @JsonKey(name: 'booking_time') required this.bookingTime,
    required this.status,
    this.notes,
    @JsonKey(name: 'damage_photos') final List<String> damagePhotos = const [],
    @JsonKey(name: 'total_amount') required this.totalAmount,
    @JsonKey(name: 'payment_status') this.paymentStatus,
    @JsonKey(name: 'payment_reference') this.paymentReference,
    @JsonKey(name: 'invoice_url') this.invoiceUrl,
    @JsonKey(name: 'admin_notes') this.adminNotes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _damagePhotos = damagePhotos,
       super._();

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'service_id')
  final String serviceId;
  @override
  final ServiceModel? service;
  @override
  @JsonKey(name: 'booking_date')
  final String bookingDate;
  @override
  @JsonKey(name: 'booking_time')
  final String bookingTime;
  @override
  final String status;
  @override
  final String? notes;
  final List<String> _damagePhotos;
  @override
  @JsonKey(name: 'damage_photos')
  List<String> get damagePhotos {
    if (_damagePhotos is EqualUnmodifiableListView) return _damagePhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_damagePhotos);
  }

  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @override
  @JsonKey(name: 'payment_reference')
  final String? paymentReference;
  @override
  @JsonKey(name: 'invoice_url')
  final String? invoiceUrl;
  @override
  @JsonKey(name: 'admin_notes')
  final String? adminNotes;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(this);
  }
}

abstract class _BookingModel extends BookingModel {
  const factory _BookingModel({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'service_id') required final String serviceId,
    final ServiceModel? service,
    @JsonKey(name: 'booking_date') required final String bookingDate,
    @JsonKey(name: 'booking_time') required final String bookingTime,
    required final String status,
    final String? notes,
    @JsonKey(name: 'damage_photos') final List<String> damagePhotos,
    @JsonKey(name: 'total_amount') required final double totalAmount,
    @JsonKey(name: 'payment_status') final String? paymentStatus,
    @JsonKey(name: 'payment_reference') final String? paymentReference,
    @JsonKey(name: 'invoice_url') final String? invoiceUrl,
    @JsonKey(name: 'admin_notes') final String? adminNotes,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$BookingModelImpl;
  const _BookingModel._() : super._();

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'service_id')
  String get serviceId;
  @override
  ServiceModel? get service;
  @override
  @JsonKey(name: 'booking_date')
  String get bookingDate;
  @override
  @JsonKey(name: 'booking_time')
  String get bookingTime;
  @override
  String get status;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'damage_photos')
  List<String> get damagePhotos;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'payment_status')
  String? get paymentStatus;
  @override
  @JsonKey(name: 'payment_reference')
  String? get paymentReference;
  @override
  @JsonKey(name: 'invoice_url')
  String? get invoiceUrl;
  @override
  @JsonKey(name: 'admin_notes')
  String? get adminNotes;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
