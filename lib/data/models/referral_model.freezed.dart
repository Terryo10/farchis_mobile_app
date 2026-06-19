// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReferralModel _$ReferralModelFromJson(Map<String, dynamic> json) {
  return _ReferralModel.fromJson(json);
}

/// @nodoc
mixin _$ReferralModel {
  @JsonKey(name: 'referral_code')
  String get referralCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_referrals')
  int get totalReferrals => throw _privateConstructorUsedError;
  @JsonKey(name: 'referred_users')
  List<dynamic> get referredUsers => throw _privateConstructorUsedError;

  /// Serializes this ReferralModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferralModelCopyWith<ReferralModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferralModelCopyWith<$Res> {
  factory $ReferralModelCopyWith(
    ReferralModel value,
    $Res Function(ReferralModel) then,
  ) = _$ReferralModelCopyWithImpl<$Res, ReferralModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'referral_code') String referralCode,
    @JsonKey(name: 'total_referrals') int totalReferrals,
    @JsonKey(name: 'referred_users') List<dynamic> referredUsers,
  });
}

/// @nodoc
class _$ReferralModelCopyWithImpl<$Res, $Val extends ReferralModel>
    implements $ReferralModelCopyWith<$Res> {
  _$ReferralModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referralCode = null,
    Object? totalReferrals = null,
    Object? referredUsers = null,
  }) {
    return _then(
      _value.copyWith(
            referralCode: null == referralCode
                ? _value.referralCode
                : referralCode // ignore: cast_nullable_to_non_nullable
                      as String,
            totalReferrals: null == totalReferrals
                ? _value.totalReferrals
                : totalReferrals // ignore: cast_nullable_to_non_nullable
                      as int,
            referredUsers: null == referredUsers
                ? _value.referredUsers
                : referredUsers // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReferralModelImplCopyWith<$Res>
    implements $ReferralModelCopyWith<$Res> {
  factory _$$ReferralModelImplCopyWith(
    _$ReferralModelImpl value,
    $Res Function(_$ReferralModelImpl) then,
  ) = __$$ReferralModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'referral_code') String referralCode,
    @JsonKey(name: 'total_referrals') int totalReferrals,
    @JsonKey(name: 'referred_users') List<dynamic> referredUsers,
  });
}

/// @nodoc
class __$$ReferralModelImplCopyWithImpl<$Res>
    extends _$ReferralModelCopyWithImpl<$Res, _$ReferralModelImpl>
    implements _$$ReferralModelImplCopyWith<$Res> {
  __$$ReferralModelImplCopyWithImpl(
    _$ReferralModelImpl _value,
    $Res Function(_$ReferralModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referralCode = null,
    Object? totalReferrals = null,
    Object? referredUsers = null,
  }) {
    return _then(
      _$ReferralModelImpl(
        referralCode: null == referralCode
            ? _value.referralCode
            : referralCode // ignore: cast_nullable_to_non_nullable
                  as String,
        totalReferrals: null == totalReferrals
            ? _value.totalReferrals
            : totalReferrals // ignore: cast_nullable_to_non_nullable
                  as int,
        referredUsers: null == referredUsers
            ? _value._referredUsers
            : referredUsers // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReferralModelImpl extends _ReferralModel {
  const _$ReferralModelImpl({
    @JsonKey(name: 'referral_code') required this.referralCode,
    @JsonKey(name: 'total_referrals') this.totalReferrals = 0,
    @JsonKey(name: 'referred_users')
    final List<dynamic> referredUsers = const [],
  }) : _referredUsers = referredUsers,
       super._();

  factory _$ReferralModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferralModelImplFromJson(json);

  @override
  @JsonKey(name: 'referral_code')
  final String referralCode;
  @override
  @JsonKey(name: 'total_referrals')
  final int totalReferrals;
  final List<dynamic> _referredUsers;
  @override
  @JsonKey(name: 'referred_users')
  List<dynamic> get referredUsers {
    if (_referredUsers is EqualUnmodifiableListView) return _referredUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_referredUsers);
  }

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferralModelImplCopyWith<_$ReferralModelImpl> get copyWith =>
      __$$ReferralModelImplCopyWithImpl<_$ReferralModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferralModelImplToJson(this);
  }
}

abstract class _ReferralModel extends ReferralModel {
  const factory _ReferralModel({
    @JsonKey(name: 'referral_code') required final String referralCode,
    @JsonKey(name: 'total_referrals') final int totalReferrals,
    @JsonKey(name: 'referred_users') final List<dynamic> referredUsers,
  }) = _$ReferralModelImpl;
  const _ReferralModel._() : super._();

  factory _ReferralModel.fromJson(Map<String, dynamic> json) =
      _$ReferralModelImpl.fromJson;

  @override
  @JsonKey(name: 'referral_code')
  String get referralCode;
  @override
  @JsonKey(name: 'total_referrals')
  int get totalReferrals;
  @override
  @JsonKey(name: 'referred_users')
  List<dynamic> get referredUsers;

  /// Create a copy of ReferralModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferralModelImplCopyWith<_$ReferralModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
