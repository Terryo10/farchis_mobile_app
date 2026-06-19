// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'referral_code')
  String? get referralCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'referred_by')
  String? get referredBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'loyalty_tier')
  String? get loyaltyTier => throw _privateConstructorUsedError;
  @JsonKey(name: 'loyalty_points')
  int get loyaltyPoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_points_earned')
  int get totalPointsEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_make')
  String? get vehicleMake => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_model')
  String? get vehicleModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_year')
  int? get vehicleYear => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_plate')
  String? get vehiclePlate => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_service_date')
  String? get lastServiceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_verified_at')
  String? get emailVerifiedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    String phone,
    String? avatar,
    @JsonKey(name: 'referral_code') String? referralCode,
    @JsonKey(name: 'referred_by') String? referredBy,
    @JsonKey(name: 'loyalty_tier') String? loyaltyTier,
    @JsonKey(name: 'loyalty_points') int loyaltyPoints,
    @JsonKey(name: 'total_points_earned') int totalPointsEarned,
    @JsonKey(name: 'vehicle_make') String? vehicleMake,
    @JsonKey(name: 'vehicle_model') String? vehicleModel,
    @JsonKey(name: 'vehicle_year') int? vehicleYear,
    @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
    @JsonKey(name: 'last_service_date') String? lastServiceDate,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? avatar = freezed,
    Object? referralCode = freezed,
    Object? referredBy = freezed,
    Object? loyaltyTier = freezed,
    Object? loyaltyPoints = null,
    Object? totalPointsEarned = null,
    Object? vehicleMake = freezed,
    Object? vehicleModel = freezed,
    Object? vehicleYear = freezed,
    Object? vehiclePlate = freezed,
    Object? lastServiceDate = freezed,
    Object? emailVerifiedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            referralCode: freezed == referralCode
                ? _value.referralCode
                : referralCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            referredBy: freezed == referredBy
                ? _value.referredBy
                : referredBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            loyaltyTier: freezed == loyaltyTier
                ? _value.loyaltyTier
                : loyaltyTier // ignore: cast_nullable_to_non_nullable
                      as String?,
            loyaltyPoints: null == loyaltyPoints
                ? _value.loyaltyPoints
                : loyaltyPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPointsEarned: null == totalPointsEarned
                ? _value.totalPointsEarned
                : totalPointsEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            vehicleMake: freezed == vehicleMake
                ? _value.vehicleMake
                : vehicleMake // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleModel: freezed == vehicleModel
                ? _value.vehicleModel
                : vehicleModel // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleYear: freezed == vehicleYear
                ? _value.vehicleYear
                : vehicleYear // ignore: cast_nullable_to_non_nullable
                      as int?,
            vehiclePlate: freezed == vehiclePlate
                ? _value.vehiclePlate
                : vehiclePlate // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastServiceDate: freezed == lastServiceDate
                ? _value.lastServiceDate
                : lastServiceDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            emailVerifiedAt: freezed == emailVerifiedAt
                ? _value.emailVerifiedAt
                : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
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
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    String phone,
    String? avatar,
    @JsonKey(name: 'referral_code') String? referralCode,
    @JsonKey(name: 'referred_by') String? referredBy,
    @JsonKey(name: 'loyalty_tier') String? loyaltyTier,
    @JsonKey(name: 'loyalty_points') int loyaltyPoints,
    @JsonKey(name: 'total_points_earned') int totalPointsEarned,
    @JsonKey(name: 'vehicle_make') String? vehicleMake,
    @JsonKey(name: 'vehicle_model') String? vehicleModel,
    @JsonKey(name: 'vehicle_year') int? vehicleYear,
    @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
    @JsonKey(name: 'last_service_date') String? lastServiceDate,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? avatar = freezed,
    Object? referralCode = freezed,
    Object? referredBy = freezed,
    Object? loyaltyTier = freezed,
    Object? loyaltyPoints = null,
    Object? totalPointsEarned = null,
    Object? vehicleMake = freezed,
    Object? vehicleModel = freezed,
    Object? vehicleYear = freezed,
    Object? vehiclePlate = freezed,
    Object? lastServiceDate = freezed,
    Object? emailVerifiedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        referralCode: freezed == referralCode
            ? _value.referralCode
            : referralCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        referredBy: freezed == referredBy
            ? _value.referredBy
            : referredBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        loyaltyTier: freezed == loyaltyTier
            ? _value.loyaltyTier
            : loyaltyTier // ignore: cast_nullable_to_non_nullable
                  as String?,
        loyaltyPoints: null == loyaltyPoints
            ? _value.loyaltyPoints
            : loyaltyPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPointsEarned: null == totalPointsEarned
            ? _value.totalPointsEarned
            : totalPointsEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        vehicleMake: freezed == vehicleMake
            ? _value.vehicleMake
            : vehicleMake // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleModel: freezed == vehicleModel
            ? _value.vehicleModel
            : vehicleModel // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleYear: freezed == vehicleYear
            ? _value.vehicleYear
            : vehicleYear // ignore: cast_nullable_to_non_nullable
                  as int?,
        vehiclePlate: freezed == vehiclePlate
            ? _value.vehiclePlate
            : vehiclePlate // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastServiceDate: freezed == lastServiceDate
            ? _value.lastServiceDate
            : lastServiceDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        emailVerifiedAt: freezed == emailVerifiedAt
            ? _value.emailVerifiedAt
            : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
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
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    @JsonKey(name: 'referral_code') this.referralCode,
    @JsonKey(name: 'referred_by') this.referredBy,
    @JsonKey(name: 'loyalty_tier') this.loyaltyTier,
    @JsonKey(name: 'loyalty_points') this.loyaltyPoints = 0,
    @JsonKey(name: 'total_points_earned') this.totalPointsEarned = 0,
    @JsonKey(name: 'vehicle_make') this.vehicleMake,
    @JsonKey(name: 'vehicle_model') this.vehicleModel,
    @JsonKey(name: 'vehicle_year') this.vehicleYear,
    @JsonKey(name: 'vehicle_plate') this.vehiclePlate,
    @JsonKey(name: 'last_service_date') this.lastServiceDate,
    @JsonKey(name: 'email_verified_at') this.emailVerifiedAt,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String? avatar;
  @override
  @JsonKey(name: 'referral_code')
  final String? referralCode;
  @override
  @JsonKey(name: 'referred_by')
  final String? referredBy;
  @override
  @JsonKey(name: 'loyalty_tier')
  final String? loyaltyTier;
  @override
  @JsonKey(name: 'loyalty_points')
  final int loyaltyPoints;
  @override
  @JsonKey(name: 'total_points_earned')
  final int totalPointsEarned;
  @override
  @JsonKey(name: 'vehicle_make')
  final String? vehicleMake;
  @override
  @JsonKey(name: 'vehicle_model')
  final String? vehicleModel;
  @override
  @JsonKey(name: 'vehicle_year')
  final int? vehicleYear;
  @override
  @JsonKey(name: 'vehicle_plate')
  final String? vehiclePlate;
  @override
  @JsonKey(name: 'last_service_date')
  final String? lastServiceDate;
  @override
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel({
    required final String id,
    required final String name,
    required final String email,
    required final String phone,
    final String? avatar,
    @JsonKey(name: 'referral_code') final String? referralCode,
    @JsonKey(name: 'referred_by') final String? referredBy,
    @JsonKey(name: 'loyalty_tier') final String? loyaltyTier,
    @JsonKey(name: 'loyalty_points') final int loyaltyPoints,
    @JsonKey(name: 'total_points_earned') final int totalPointsEarned,
    @JsonKey(name: 'vehicle_make') final String? vehicleMake,
    @JsonKey(name: 'vehicle_model') final String? vehicleModel,
    @JsonKey(name: 'vehicle_year') final int? vehicleYear,
    @JsonKey(name: 'vehicle_plate') final String? vehiclePlate,
    @JsonKey(name: 'last_service_date') final String? lastServiceDate,
    @JsonKey(name: 'email_verified_at') final String? emailVerifiedAt,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get phone;
  @override
  String? get avatar;
  @override
  @JsonKey(name: 'referral_code')
  String? get referralCode;
  @override
  @JsonKey(name: 'referred_by')
  String? get referredBy;
  @override
  @JsonKey(name: 'loyalty_tier')
  String? get loyaltyTier;
  @override
  @JsonKey(name: 'loyalty_points')
  int get loyaltyPoints;
  @override
  @JsonKey(name: 'total_points_earned')
  int get totalPointsEarned;
  @override
  @JsonKey(name: 'vehicle_make')
  String? get vehicleMake;
  @override
  @JsonKey(name: 'vehicle_model')
  String? get vehicleModel;
  @override
  @JsonKey(name: 'vehicle_year')
  int? get vehicleYear;
  @override
  @JsonKey(name: 'vehicle_plate')
  String? get vehiclePlate;
  @override
  @JsonKey(name: 'last_service_date')
  String? get lastServiceDate;
  @override
  @JsonKey(name: 'email_verified_at')
  String? get emailVerifiedAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
