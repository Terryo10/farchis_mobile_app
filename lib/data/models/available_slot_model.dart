import 'package:json_annotation/json_annotation.dart';

part 'available_slot_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AvailableSlotModel {
  final DateTime date;
  final List<String> slots;

  const AvailableSlotModel({
    required this.date,
    required this.slots,
  });

  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) => _$AvailableSlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableSlotModelToJson(this);

  AvailableSlotModel copyWith({
    DateTime? date,
    List<String>? slots,
  }) {
    return AvailableSlotModel(
      date: date ?? this.date,
      slots: slots ?? this.slots,
    );
  }
}
