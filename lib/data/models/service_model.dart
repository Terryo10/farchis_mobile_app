import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel, EquatableMixin {
  const ServiceModel._();

  const factory ServiceModel({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? category,
    required double price,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    String? image,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  @override
  List<Object?> get props => [id, name, slug, price, category];
}
