// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'available_slot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AvailableSlotModel _$AvailableSlotModelFromJson(Map<String, dynamic> json) {
  return _AvailableSlotModel.fromJson(json);
}

/// @nodoc
mixin _$AvailableSlotModel {
  @JsonKey(name: 'date')
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'slots')
  List<String> get slots => throw _privateConstructorUsedError;

  /// Serializes this AvailableSlotModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableSlotModelCopyWith<AvailableSlotModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableSlotModelCopyWith<$Res> {
  factory $AvailableSlotModelCopyWith(
    AvailableSlotModel value,
    $Res Function(AvailableSlotModel) then,
  ) = _$AvailableSlotModelCopyWithImpl<$Res, AvailableSlotModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'date') String date,
    @JsonKey(name: 'slots') List<String> slots,
  });
}

/// @nodoc
class _$AvailableSlotModelCopyWithImpl<$Res, $Val extends AvailableSlotModel>
    implements $AvailableSlotModelCopyWith<$Res> {
  _$AvailableSlotModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? slots = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            slots: null == slots
                ? _value.slots
                : slots // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvailableSlotModelImplCopyWith<$Res>
    implements $AvailableSlotModelCopyWith<$Res> {
  factory _$$AvailableSlotModelImplCopyWith(
    _$AvailableSlotModelImpl value,
    $Res Function(_$AvailableSlotModelImpl) then,
  ) = __$$AvailableSlotModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'date') String date,
    @JsonKey(name: 'slots') List<String> slots,
  });
}

/// @nodoc
class __$$AvailableSlotModelImplCopyWithImpl<$Res>
    extends _$AvailableSlotModelCopyWithImpl<$Res, _$AvailableSlotModelImpl>
    implements _$$AvailableSlotModelImplCopyWith<$Res> {
  __$$AvailableSlotModelImplCopyWithImpl(
    _$AvailableSlotModelImpl _value,
    $Res Function(_$AvailableSlotModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvailableSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? slots = null}) {
    return _then(
      _$AvailableSlotModelImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        slots: null == slots
            ? _value._slots
            : slots // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableSlotModelImpl extends _AvailableSlotModel {
  const _$AvailableSlotModelImpl({
    @JsonKey(name: 'date') required this.date,
    @JsonKey(name: 'slots') final List<String> slots = const [],
  }) : _slots = slots,
       super._();

  factory _$AvailableSlotModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableSlotModelImplFromJson(json);

  @override
  @JsonKey(name: 'date')
  final String date;
  final List<String> _slots;
  @override
  @JsonKey(name: 'slots')
  List<String> get slots {
    if (_slots is EqualUnmodifiableListView) return _slots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_slots);
  }

  /// Create a copy of AvailableSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableSlotModelImplCopyWith<_$AvailableSlotModelImpl> get copyWith =>
      __$$AvailableSlotModelImplCopyWithImpl<_$AvailableSlotModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableSlotModelImplToJson(this);
  }
}

abstract class _AvailableSlotModel extends AvailableSlotModel {
  const factory _AvailableSlotModel({
    @JsonKey(name: 'date') required final String date,
    @JsonKey(name: 'slots') final List<String> slots,
  }) = _$AvailableSlotModelImpl;
  const _AvailableSlotModel._() : super._();

  factory _AvailableSlotModel.fromJson(Map<String, dynamic> json) =
      _$AvailableSlotModelImpl.fromJson;

  @override
  @JsonKey(name: 'date')
  String get date;
  @override
  @JsonKey(name: 'slots')
  List<String> get slots;

  /// Create a copy of AvailableSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableSlotModelImplCopyWith<_$AvailableSlotModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
