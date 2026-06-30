import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../data/models/vehicle_model.dart';
import 'my_vehicles_event.dart';
import 'my_vehicles_state.dart';

class MyVehiclesBloc extends Bloc<MyVehiclesEvent, MyVehiclesState> {
  final AuthBloc authBloc;

  MyVehiclesBloc({required this.authBloc}) : super(const MyVehiclesState()) {
    on<LoadVehicles>(_onLoad);
    on<AddVehicle>(_onAdd);
    on<UpdateVehicle>(_onUpdate);
    on<DeleteVehicle>(_onDelete);
  }

  void _onLoad(LoadVehicles event, Emitter<MyVehiclesState> emit) {
    // Seed from the single vehicle stored on the user profile (legacy field).
    // When the backend exposes a multi-vehicle endpoint this is the only place
    // that needs updating.
    final authState = authBloc.state;
    if (authState is Authenticated) {
      final user = authState.user;
      if (user.vehicleMake != null && user.vehiclePlate != null) {
        final seeded = VehicleModel(
          id: 'user_primary',
          regNumber: user.vehiclePlate ?? '',
          make: user.vehicleMake ?? '',
          model: user.vehicleModel ?? '',
          color: '',
        );
        emit(state.copyWith(vehicles: [seeded], isLoading: false));
        return;
      }
    }
    emit(state.copyWith(vehicles: [], isLoading: false));
  }

  void _onAdd(AddVehicle event, Emitter<MyVehiclesState> emit) {
    final updated = List<VehicleModel>.from(state.vehicles)..add(event.vehicle);
    emit(state.copyWith(vehicles: updated));
  }

  void _onUpdate(UpdateVehicle event, Emitter<MyVehiclesState> emit) {
    final updated = state.vehicles.map((v) {
      return v.id == event.vehicle.id ? event.vehicle : v;
    }).toList();
    emit(state.copyWith(vehicles: updated));
  }

  void _onDelete(DeleteVehicle event, Emitter<MyVehiclesState> emit) {
    final updated = state.vehicles.where((v) => v.id != event.id).toList();
    emit(state.copyWith(vehicles: updated));
  }
}
