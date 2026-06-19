// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GalleryItemModel _$GalleryItemModelFromJson(Map<String, dynamic> json) {
  return _GalleryItemModel.fromJson(json);
}

/// @nodoc
mixin _$GalleryItemModel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  String get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'before_image')
  String? get beforeImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'after_image')
  String? get afterImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'caption')
  String? get caption => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GalleryItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GalleryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GalleryItemModelCopyWith<GalleryItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GalleryItemModelCopyWith<$Res> {
  factory $GalleryItemModelCopyWith(
    GalleryItemModel value,
    $Res Function(GalleryItemModel) then,
  ) = _$GalleryItemModelCopyWithImpl<$Res, GalleryItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'booking_id') String bookingId,
    @JsonKey(name: 'before_image') String? beforeImage,
    @JsonKey(name: 'after_image') String? afterImage,
    @JsonKey(name: 'caption') String? caption,
    @JsonKey(name: 'is_public') bool isPublic,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$GalleryItemModelCopyWithImpl<$Res, $Val extends GalleryItemModel>
    implements $GalleryItemModelCopyWith<$Res> {
  _$GalleryItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GalleryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? beforeImage = freezed,
    Object? afterImage = freezed,
    Object? caption = freezed,
    Object? isPublic = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingId: null == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String,
            beforeImage: freezed == beforeImage
                ? _value.beforeImage
                : beforeImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            afterImage: freezed == afterImage
                ? _value.afterImage
                : afterImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
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
abstract class _$$GalleryItemModelImplCopyWith<$Res>
    implements $GalleryItemModelCopyWith<$Res> {
  factory _$$GalleryItemModelImplCopyWith(
    _$GalleryItemModelImpl value,
    $Res Function(_$GalleryItemModelImpl) then,
  ) = __$$GalleryItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') String id,
    @JsonKey(name: 'booking_id') String bookingId,
    @JsonKey(name: 'before_image') String? beforeImage,
    @JsonKey(name: 'after_image') String? afterImage,
    @JsonKey(name: 'caption') String? caption,
    @JsonKey(name: 'is_public') bool isPublic,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$GalleryItemModelImplCopyWithImpl<$Res>
    extends _$GalleryItemModelCopyWithImpl<$Res, _$GalleryItemModelImpl>
    implements _$$GalleryItemModelImplCopyWith<$Res> {
  __$$GalleryItemModelImplCopyWithImpl(
    _$GalleryItemModelImpl _value,
    $Res Function(_$GalleryItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GalleryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? beforeImage = freezed,
    Object? afterImage = freezed,
    Object? caption = freezed,
    Object? isPublic = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$GalleryItemModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingId: null == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String,
        beforeImage: freezed == beforeImage
            ? _value.beforeImage
            : beforeImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        afterImage: freezed == afterImage
            ? _value.afterImage
            : afterImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
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
class _$GalleryItemModelImpl extends _GalleryItemModel {
  const _$GalleryItemModelImpl({
    @JsonKey(name: 'id') required this.id,
    @JsonKey(name: 'booking_id') required this.bookingId,
    @JsonKey(name: 'before_image') this.beforeImage,
    @JsonKey(name: 'after_image') this.afterImage,
    @JsonKey(name: 'caption') this.caption,
    @JsonKey(name: 'is_public') this.isPublic = false,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : super._();

  factory _$GalleryItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GalleryItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'booking_id')
  final String bookingId;
  @override
  @JsonKey(name: 'before_image')
  final String? beforeImage;
  @override
  @JsonKey(name: 'after_image')
  final String? afterImage;
  @override
  @JsonKey(name: 'caption')
  final String? caption;
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  /// Create a copy of GalleryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GalleryItemModelImplCopyWith<_$GalleryItemModelImpl> get copyWith =>
      __$$GalleryItemModelImplCopyWithImpl<_$GalleryItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GalleryItemModelImplToJson(this);
  }
}

abstract class _GalleryItemModel extends GalleryItemModel {
  const factory _GalleryItemModel({
    @JsonKey(name: 'id') required final String id,
    @JsonKey(name: 'booking_id') required final String bookingId,
    @JsonKey(name: 'before_image') final String? beforeImage,
    @JsonKey(name: 'after_image') final String? afterImage,
    @JsonKey(name: 'caption') final String? caption,
    @JsonKey(name: 'is_public') final bool isPublic,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$GalleryItemModelImpl;
  const _GalleryItemModel._() : super._();

  factory _GalleryItemModel.fromJson(Map<String, dynamic> json) =
      _$GalleryItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'booking_id')
  String get bookingId;
  @override
  @JsonKey(name: 'before_image')
  String? get beforeImage;
  @override
  @JsonKey(name: 'after_image')
  String? get afterImage;
  @override
  @JsonKey(name: 'caption')
  String? get caption;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of GalleryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GalleryItemModelImplCopyWith<_$GalleryItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
