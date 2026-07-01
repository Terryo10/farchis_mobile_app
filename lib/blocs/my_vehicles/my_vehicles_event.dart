import 'package:equatable/equatable.dart';

sealed class MyVehiclesEvent extends Equatable {
  const MyVehiclesEvent();
  @override
  List<Object?> get props => [];
}

class LoadVehicles extends MyVehiclesEvent {
  const LoadVehicles();
}

class AddVehicle extends MyVehiclesEvent {
  final Map<String, dynamic> payload;
  const AddVehicle(this.payload);
  @override
  List<Object?> get props => [payload];
}

class UpdateVehicle extends MyVehiclesEvent {
  final int id;
  final Map<String, dynamic> payload;
  const UpdateVehicle(this.id, this.payload);
  @override
  List<Object?> get props => [id, payload];
}

class DeleteVehicle extends MyVehiclesEvent {
  final int id;
  const DeleteVehicle(this.id);
  @override
  List<Object?> get props => [id];
}

class SetPrimaryVehicle extends MyVehiclesEvent {
  final int id;
  const SetPrimaryVehicle(this.id);
  @override
  List<Object?> get props => [id];
}
