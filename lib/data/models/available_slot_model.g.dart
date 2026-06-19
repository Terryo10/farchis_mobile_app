// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvailableSlotModelImpl _$$AvailableSlotModelImplFromJson(
  Map<String, dynamic> json,
) => _$AvailableSlotModelImpl(
  date: json['date'] as String,
  slots:
      (json['slots'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$AvailableSlotModelImplToJson(
  _$AvailableSlotModelImpl instance,
) => <String, dynamic>{'date': instance.date, 'slots': instance.slots};
