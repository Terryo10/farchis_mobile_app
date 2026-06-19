import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'available_slot_model.freezed.dart';
part 'available_slot_model.g.dart';

@freezed
class AvailableSlotModel with _$AvailableSlotModel, EquatableMixin {
  const AvailableSlotModel._();

  const factory AvailableSlotModel({
    @JsonKey(name: 'date') required String date,
    @JsonKey(name: 'slots') @Default([]) List<String> slots,
  }) = _AvailableSlotModel;

  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableSlotModelFromJson(json);

  @override
  List<Object?> get props => [date, slots];
}
