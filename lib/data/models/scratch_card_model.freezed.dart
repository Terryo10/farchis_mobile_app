// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scratch_card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScratchCardModel _$ScratchCardModelFromJson(Map<String, dynamic> json) {
  return _ScratchCardModel.fromJson(json);
}

/// @nodoc
mixin _$ScratchCardModel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  String? get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'prize_type')
  String get prizeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'prize_value')
  double get prizeValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_scratched')
  bool get isScratched => throw _privateConstructorUsedError;
  @JsonKey(name: 'scratched_at')
  String? get scratchedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  String get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ScratchCardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScratchCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScratchCardModelCopyWith<ScratchCardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScratchCardModelCopyWith<$Res> {
  factory $ScratchCardModelCopyWith(
    ScratchCardModel value,
    $Res Function(ScratchCardModel) then,
  ) = _$ScratchCardModelCopyWithImpl<$Res, ScratchCardModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'prize_type') String prizeType,
    @JsonKey(name: 'prize_value') double prizeValue,
    @JsonKey(name: 'is_scratched') bool isScratched,
    @JsonKey(name: 'scratched_at') String? scratchedAt,
    @JsonKey(name: 'expires_at') String expiresAt,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$ScratchCardModelCopyWithImpl<$Res, $Val extends ScratchCardModel>
    implements $ScratchCardModelCopyWith<$Res> {
  _$ScratchCardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScratchCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = freezed,
    Object? prizeType = null,
    Object? prizeValue = null,
    Object? isScratched = null,
    Object? scratchedAt = freezed,
    Object? expiresAt = null,
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
            prizeType: null == prizeType
                ? _value.prizeType
                : prizeType // ignore: cast_nullable_to_non_nullable
                      as String,
            prizeValue: null == prizeValue
                ? _value.prizeValue
                : prizeValue // ignore: cast_nullable_to_non_nullable
                      as double,
            isScratched: null == isScratched
                ? _value.isScratched
                : isScratched // ignore: cast_nullable_to_non_nullable
                      as bool,
            scratchedAt: freezed == scratchedAt
                ? _value.scratchedAt
                : scratchedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$ScratchCardModelImplCopyWith<$Res>
    implements $ScratchCardModelCopyWith<$Res> {
  factory _$$ScratchCardModelImplCopyWith(
    _$ScratchCardModelImpl value,
    $Res Function(_$ScratchCardModelImpl) then,
  ) = __$$ScratchCardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'prize_type') String prizeType,
    @JsonKey(name: 'prize_value') double prizeValue,
    @JsonKey(name: 'is_scratched') bool isScratched,
    @JsonKey(name: 'scratched_at') String? scratchedAt,
    @JsonKey(name: 'expires_at') String expiresAt,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$ScratchCardModelImplCopyWithImpl<$Res>
    extends _$ScratchCardModelCopyWithImpl<$Res, _$ScratchCardModelImpl>
    implements _$$ScratchCardModelImplCopyWith<$Res> {
  __$$ScratchCardModelImplCopyWithImpl(
    _$ScratchCardModelImpl _value,
    $Res Function(_$ScratchCardModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScratchCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookingId = freezed,
    Object? prizeType = null,
    Object? prizeValue = null,
    Object? isScratched = null,
    Object? scratchedAt = freezed,
    Object? expiresAt = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ScratchCardModelImpl(
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
        prizeType: null == prizeType
            ? _value.prizeType
            : prizeType // ignore: cast_nullable_to_non_nullable
                  as String,
        prizeValue: null == prizeValue
            ? _value.prizeValue
            : prizeValue // ignore: cast_nullable_to_non_nullable
                  as double,
        isScratched: null == isScratched
            ? _value.isScratched
            : isScratched // ignore: cast_nullable_to_non_nullable
                  as bool,
        scratchedAt: freezed == scratchedAt
            ? _value.scratchedAt
            : scratchedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$ScratchCardModelImpl extends _ScratchCardModel {
  const _$ScratchCardModelImpl({
    @JsonKey(name: 'id') required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'booking_id') this.bookingId,
    @JsonKey(name: 'prize_type') required this.prizeType,
    @JsonKey(name: 'prize_value') required this.prizeValue,
    @JsonKey(name: 'is_scratched') this.isScratched = false,
    @JsonKey(name: 'scratched_at') this.scratchedAt,
    @JsonKey(name: 'expires_at') required this.expiresAt,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : super._();

  factory _$ScratchCardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScratchCardModelImplFromJson(json);

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
  @JsonKey(name: 'prize_type')
  final String prizeType;
  @override
  @JsonKey(name: 'prize_value')
  final double prizeValue;
  @override
  @JsonKey(name: 'is_scratched')
  final bool isScratched;
  @override
  @JsonKey(name: 'scratched_at')
  final String? scratchedAt;
  @override
  @JsonKey(name: 'expires_at')
  final String expiresAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  /// Create a copy of ScratchCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScratchCardModelImplCopyWith<_$ScratchCardModelImpl> get copyWith =>
      __$$ScratchCardModelImplCopyWithImpl<_$ScratchCardModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScratchCardModelImplToJson(this);
  }
}

abstract class _ScratchCardModel extends ScratchCardModel {
  const factory _ScratchCardModel({
    @JsonKey(name: 'id') required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'booking_id') final String? bookingId,
    @JsonKey(name: 'prize_type') required final String prizeType,
    @JsonKey(name: 'prize_value') required final double prizeValue,
    @JsonKey(name: 'is_scratched') final bool isScratched,
    @JsonKey(name: 'scratched_at') final String? scratchedAt,
    @JsonKey(name: 'expires_at') required final String expiresAt,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$ScratchCardModelImpl;
  const _ScratchCardModel._() : super._();

  factory _ScratchCardModel.fromJson(Map<String, dynamic> json) =
      _$ScratchCardModelImpl.fromJson;

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
  @JsonKey(name: 'prize_type')
  String get prizeType;
  @override
  @JsonKey(name: 'prize_value')
  double get prizeValue;
  @override
  @JsonKey(name: 'is_scratched')
  bool get isScratched;
  @override
  @JsonKey(name: 'scratched_at')
  String? get scratchedAt;
  @override
  @JsonKey(name: 'expires_at')
  String get expiresAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of ScratchCardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScratchCardModelImplCopyWith<_$ScratchCardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
