import 'package:equatable/equatable.dart';

/// Represents a saved vehicle in the My Vehicles list.
/// Stored in [MyVehiclesBloc] state (in-memory).  When the backend adds a
/// dedicated multi-vehicle endpoint this model gains `fromJson`/`toJson`.
class VehicleModel extends Equatable {
  final String id; // UUID generated locally
  final String regNumber;
  final String make;
  final String model;
  final String color;

  const VehicleModel({
    required this.id,
    required this.regNumber,
    required this.make,
    required this.model,
    required this.color,
  });

  VehicleModel copyWith({
    String? id,
    String? regNumber,
    String? make,
    String? model,
    String? color,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      regNumber: regNumber ?? this.regNumber,
      make: make ?? this.make,
      model: model ?? this.model,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, regNumber, make, model, color];
}
