import 'package:equatable/equatable.dart';
import '../../data/models/vehicle_model.dart';

class MyVehiclesState extends Equatable {
  final List<VehicleModel> vehicles;
  final bool isLoading;

  const MyVehiclesState({
    this.vehicles = const [],
    this.isLoading = false,
  });

  MyVehiclesState copyWith({
    List<VehicleModel>? vehicles,
    bool? isLoading,
  }) {
    return MyVehiclesState(
      vehicles: vehicles ?? this.vehicles,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [vehicles, isLoading];
}
