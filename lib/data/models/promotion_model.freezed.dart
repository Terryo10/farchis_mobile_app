// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) {
  return _PromotionModel.fromJson(json);
}

/// @nodoc
mixin _$PromotionModel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'body')
  String? get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PromotionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PromotionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromotionModelCopyWith<PromotionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromotionModelCopyWith<$Res> {
  factory $PromotionModelCopyWith(
    PromotionModel value,
    $Res Function(PromotionModel) then,
  ) = _$PromotionModelCopyWithImpl<$Res, PromotionModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'title') String title,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$PromotionModelCopyWithImpl<$Res, $Val extends PromotionModel>
    implements $PromotionModelCopyWith<$Res> {
  _$PromotionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PromotionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = freezed,
    Object? image = freezed,
    Object? type = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: freezed == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String?,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$PromotionModelImplCopyWith<$Res>
    implements $PromotionModelCopyWith<$Res> {
  factory _$$PromotionModelImplCopyWith(
    _$PromotionModelImpl value,
    $Res Function(_$PromotionModelImpl) then,
  ) = __$$PromotionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'title') String title,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$PromotionModelImplCopyWithImpl<$Res>
    extends _$PromotionModelCopyWithImpl<$Res, _$PromotionModelImpl>
    implements _$$PromotionModelImplCopyWith<$Res> {
  __$$PromotionModelImplCopyWithImpl(
    _$PromotionModelImpl _value,
    $Res Function(_$PromotionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PromotionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = freezed,
    Object? image = freezed,
    Object? type = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$PromotionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: freezed == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String?,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$PromotionModelImpl extends _PromotionModel {
  const _$PromotionModelImpl({
    @JsonKey(name: 'id') required this.id,
    @JsonKey(name: 'title') required this.title,
    @JsonKey(name: 'body') this.body,
    @JsonKey(name: 'image') this.image,
    @JsonKey(name: 'type') this.type,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : super._();

  factory _$PromotionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromotionModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'body')
  final String? body;
  @override
  @JsonKey(name: 'image')
  final String? image;
  @override
  @JsonKey(name: 'type')
  final String? type;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  /// Create a copy of PromotionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromotionModelImplCopyWith<_$PromotionModelImpl> get copyWith =>
      __$$PromotionModelImplCopyWithImpl<_$PromotionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PromotionModelImplToJson(this);
  }
}

abstract class _PromotionModel extends PromotionModel {
  const factory _PromotionModel({
    @JsonKey(name: 'id') required final String id,
    @JsonKey(name: 'title') required final String title,
    @JsonKey(name: 'body') final String? body,
    @JsonKey(name: 'image') final String? image,
    @JsonKey(name: 'type') final String? type,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$PromotionModelImpl;
  const _PromotionModel._() : super._();

  factory _PromotionModel.fromJson(Map<String, dynamic> json) =
      _$PromotionModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'body')
  String? get body;
  @override
  @JsonKey(name: 'image')
  String? get image;
  @override
  @JsonKey(name: 'type')
  String? get type;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of PromotionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromotionModelImplCopyWith<_$PromotionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
