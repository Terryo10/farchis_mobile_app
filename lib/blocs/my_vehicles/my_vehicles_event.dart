import 'package:equatable/equatable.dart';
import '../../data/models/vehicle_model.dart';

sealed class MyVehiclesEvent extends Equatable {
  const MyVehiclesEvent();
  @override
  List<Object?> get props => [];
}

class LoadVehicles extends MyVehiclesEvent {
  const LoadVehicles();
}

class AddVehicle extends MyVehiclesEvent {
  final VehicleModel vehicle;
  const AddVehicle(this.vehicle);
  @override
  List<Object?> get props => [vehicle];
}

class UpdateVehicle extends MyVehiclesEvent {
  final VehicleModel vehicle;
  const UpdateVehicle(this.vehicle);
  @override
  List<Object?> get props => [vehicle];
}

class DeleteVehicle extends MyVehiclesEvent {
  final String id;
  const DeleteVehicle(this.id);
  @override
  List<Object?> get props => [id];
}
