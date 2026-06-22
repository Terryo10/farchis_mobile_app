// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableSlotModel _$AvailableSlotModelFromJson(Map<String, dynamic> json) =>
    AvailableSlotModel(
      date: DateTime.parse(json['date'] as String),
      slots: (json['slots'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AvailableSlotModelToJson(AvailableSlotModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'slots': instance.slots,
    };
