import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class ReviewModel with _$ReviewModel, EquatableMixin {
  const ReviewModel._();

  const factory ReviewModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'rating') required int rating,
    @JsonKey(name: 'comment') String? comment,
    @JsonKey(name: 'is_approved') @Default(false) bool isApproved,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  @override
  List<Object?> get props => [id, bookingId, rating];
}
