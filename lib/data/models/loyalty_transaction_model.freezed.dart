// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoyaltyTransactionModel _$LoyaltyTransactionModelFromJson(
  Map<String, dynamic> json,
) {
  return _LoyaltyTransactionModel.fromJson(json);
}

/// @nodoc
mixin _$LoyaltyTransactionModel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  String? get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'points')
  int get points => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LoyaltyTransactionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoyaltyTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoyaltyTransactionModelCopyWith<LoyaltyTransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoyaltyTransactionModelCopyWith<$Res> {
  factory $LoyaltyTransactionModelCopyWith(
    LoyaltyTransactionModel value,
    $Res Function(LoyaltyTransactionModel) then,
  ) = _$LoyaltyTransactionModelCopyWithImpl<$Res, LoyaltyTransactionModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'points') int points,
    @JsonKey(name: 'type') String type,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$LoyaltyTransactionModelCopyWithImpl<
  $Res,
  $Val extends LoyaltyTransactionModel
>
    implements $LoyaltyTransactionModelCopyWith<$Res> {
  _$LoyaltyTransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoyaltyTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = freezed,
    Object? points = null,
    Object? type = null,
    Object? description = freezed,
    Object? createdAt = freezed,
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
            bookingId: freezed == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String?,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoyaltyTransactionModelImplCopyWith<$Res>
    implements $LoyaltyTransactionModelCopyWith<$Res> {
  factory _$$LoyaltyTransactionModelImplCopyWith(
    _$LoyaltyTransactionModelImpl value,
    $Res Function(_$LoyaltyTransactionModelImpl) then,
  ) = __$$LoyaltyTransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'points') int points,
    @JsonKey(name: 'type') String type,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$LoyaltyTransactionModelImplCopyWithImpl<$Res>
    extends
        _$LoyaltyTransactionModelCopyWithImpl<
          $Res,
          _$LoyaltyTransactionModelImpl
        >
    implements _$$LoyaltyTransactionModelImplCopyWith<$Res> {
  __$$LoyaltyTransactionModelImplCopyWithImpl(
    _$LoyaltyTransactionModelImpl _value,
    $Res Function(_$LoyaltyTransactionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoyaltyTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = freezed,
    Object? points = null,
    Object? type = null,
    Object? description = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$LoyaltyTransactionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingId: freezed == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String?,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoyaltyTransactionModelImpl extends _LoyaltyTransactionModel {
  const _$LoyaltyTransactionModelImpl({
    @JsonKey(name: 'id') required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'booking_id') this.bookingId,
    @JsonKey(name: 'points') required this.points,
    @JsonKey(name: 'type') required this.type,
    @JsonKey(name: 'description') this.description,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : super._();

  factory _$LoyaltyTransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoyaltyTransactionModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'booking_id')
  final String? bookingId;
  @override
  @JsonKey(name: 'points')
  final int points;
  @override
  @JsonKey(name: 'type')
  final String type;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  /// Create a copy of LoyaltyTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoyaltyTransactionModelImplCopyWith<_$LoyaltyTransactionModelImpl>
  get copyWith =>
      __$$LoyaltyTransactionModelImplCopyWithImpl<
        _$LoyaltyTransactionModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoyaltyTransactionModelImplToJson(this);
  }
}

abstract class _LoyaltyTransactionModel extends LoyaltyTransactionModel {
  const factory _LoyaltyTransactionModel({
    @JsonKey(name: 'id') required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'booking_id') final String? bookingId,
    @JsonKey(name: 'points') required final int points,
    @JsonKey(name: 'type') required final String type,
    @JsonKey(name: 'description') final String? description,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$LoyaltyTransactionModelImpl;
  const _LoyaltyTransactionModel._() : super._();

  factory _LoyaltyTransactionModel.fromJson(Map<String, dynamic> json) =
      _$LoyaltyTransactionModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'booking_id')
  String? get bookingId;
  @override
  @JsonKey(name: 'points')
  int get points;
  @override
  @JsonKey(name: 'type')
  String get type;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of LoyaltyTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoyaltyTransactionModelImplCopyWith<_$LoyaltyTransactionModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
