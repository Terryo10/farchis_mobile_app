// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_wallet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoyaltyWalletModel _$LoyaltyWalletModelFromJson(Map<String, dynamic> json) {
  return _LoyaltyWalletModel.fromJson(json);
}

/// @nodoc
mixin _$LoyaltyWalletModel {
  @JsonKey(name: 'balance')
  int get balance => throw _privateConstructorUsedError;
  @JsonKey(name: 'tier')
  String? get tier => throw _privateConstructorUsedError;
  @JsonKey(name: 'tier_progress')
  double get tierProgress => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_tier_points')
  int? get nextTierPoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'transactions')
  List<LoyaltyTransactionModel> get transactions =>
      throw _privateConstructorUsedError;

  /// Serializes this LoyaltyWalletModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoyaltyWalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoyaltyWalletModelCopyWith<LoyaltyWalletModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoyaltyWalletModelCopyWith<$Res> {
  factory $LoyaltyWalletModelCopyWith(
    LoyaltyWalletModel value,
    $Res Function(LoyaltyWalletModel) then,
  ) = _$LoyaltyWalletModelCopyWithImpl<$Res, LoyaltyWalletModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'balance') int balance,
    @JsonKey(name: 'tier') String? tier,
    @JsonKey(name: 'tier_progress') double tierProgress,
    @JsonKey(name: 'next_tier_points') int? nextTierPoints,
    @JsonKey(name: 'transactions') List<LoyaltyTransactionModel> transactions,
  });
}

/// @nodoc
class _$LoyaltyWalletModelCopyWithImpl<$Res, $Val extends LoyaltyWalletModel>
    implements $LoyaltyWalletModelCopyWith<$Res> {
  _$LoyaltyWalletModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoyaltyWalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balance = null,
    Object? tier = freezed,
    Object? tierProgress = null,
    Object? nextTierPoints = freezed,
    Object? transactions = null,
  }) {
    return _then(
      _value.copyWith(
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as int,
            tier: freezed == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as String?,
            tierProgress: null == tierProgress
                ? _value.tierProgress
                : tierProgress // ignore: cast_nullable_to_non_nullable
                      as double,
            nextTierPoints: freezed == nextTierPoints
                ? _value.nextTierPoints
                : nextTierPoints // ignore: cast_nullable_to_non_nullable
                      as int?,
            transactions: null == transactions
                ? _value.transactions
                : transactions // ignore: cast_nullable_to_non_nullable
                      as List<LoyaltyTransactionModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoyaltyWalletModelImplCopyWith<$Res>
    implements $LoyaltyWalletModelCopyWith<$Res> {
  factory _$$LoyaltyWalletModelImplCopyWith(
    _$LoyaltyWalletModelImpl value,
    $Res Function(_$LoyaltyWalletModelImpl) then,
  ) = __$$LoyaltyWalletModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'balance') int balance,
    @JsonKey(name: 'tier') String? tier,
    @JsonKey(name: 'tier_progress') double tierProgress,
    @JsonKey(name: 'next_tier_points') int? nextTierPoints,
    @JsonKey(name: 'transactions') List<LoyaltyTransactionModel> transactions,
  });
}

/// @nodoc
class __$$LoyaltyWalletModelImplCopyWithImpl<$Res>
    extends _$LoyaltyWalletModelCopyWithImpl<$Res, _$LoyaltyWalletModelImpl>
    implements _$$LoyaltyWalletModelImplCopyWith<$Res> {
  __$$LoyaltyWalletModelImplCopyWithImpl(
    _$LoyaltyWalletModelImpl _value,
    $Res Function(_$LoyaltyWalletModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoyaltyWalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balance = null,
    Object? tier = freezed,
    Object? tierProgress = null,
    Object? nextTierPoints = freezed,
    Object? transactions = null,
  }) {
    return _then(
      _$LoyaltyWalletModelImpl(
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as int,
        tier: freezed == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as String?,
        tierProgress: null == tierProgress
            ? _value.tierProgress
            : tierProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        nextTierPoints: freezed == nextTierPoints
            ? _value.nextTierPoints
            : nextTierPoints // ignore: cast_nullable_to_non_nullable
                  as int?,
        transactions: null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<LoyaltyTransactionModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoyaltyWalletModelImpl extends _LoyaltyWalletModel {
  const _$LoyaltyWalletModelImpl({
    @JsonKey(name: 'balance') this.balance = 0,
    @JsonKey(name: 'tier') this.tier,
    @JsonKey(name: 'tier_progress') this.tierProgress = 0,
    @JsonKey(name: 'next_tier_points') this.nextTierPoints,
    @JsonKey(name: 'transactions')
    final List<LoyaltyTransactionModel> transactions = const [],
  }) : _transactions = transactions,
       super._();

  factory _$LoyaltyWalletModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoyaltyWalletModelImplFromJson(json);

  @override
  @JsonKey(name: 'balance')
  final int balance;
  @override
  @JsonKey(name: 'tier')
  final String? tier;
  @override
  @JsonKey(name: 'tier_progress')
  final double tierProgress;
  @override
  @JsonKey(name: 'next_tier_points')
  final int? nextTierPoints;
  final List<LoyaltyTransactionModel> _transactions;
  @override
  @JsonKey(name: 'transactions')
  List<LoyaltyTransactionModel> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  /// Create a copy of LoyaltyWalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoyaltyWalletModelImplCopyWith<_$LoyaltyWalletModelImpl> get copyWith =>
      __$$LoyaltyWalletModelImplCopyWithImpl<_$LoyaltyWalletModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoyaltyWalletModelImplToJson(this);
  }
}

abstract class _LoyaltyWalletModel extends LoyaltyWalletModel {
  const factory _LoyaltyWalletModel({
    @JsonKey(name: 'balance') final int balance,
    @JsonKey(name: 'tier') final String? tier,
    @JsonKey(name: 'tier_progress') final double tierProgress,
    @JsonKey(name: 'next_tier_points') final int? nextTierPoints,
    @JsonKey(name: 'transactions')
    final List<LoyaltyTransactionModel> transactions,
  }) = _$LoyaltyWalletModelImpl;
  const _LoyaltyWalletModel._() : super._();

  factory _LoyaltyWalletModel.fromJson(Map<String, dynamic> json) =
      _$LoyaltyWalletModelImpl.fromJson;

  @override
  @JsonKey(name: 'balance')
  int get balance;
  @override
  @JsonKey(name: 'tier')
  String? get tier;
  @override
  @JsonKey(name: 'tier_progress')
  double get tierProgress;
  @override
  @JsonKey(name: 'next_tier_points')
  int? get nextTierPoints;
  @override
  @JsonKey(name: 'transactions')
  List<LoyaltyTransactionModel> get transactions;

  /// Create a copy of LoyaltyWalletModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoyaltyWalletModelImplCopyWith<_$LoyaltyWalletModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
