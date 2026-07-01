import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/vehicle_repository.dart';
import 'my_vehicles_event.dart';
import 'my_vehicles_state.dart';

class MyVehiclesBloc extends Bloc<MyVehiclesEvent, MyVehiclesState> {
  final VehicleRepository repository;

  MyVehiclesBloc({required this.repository}) : super(const MyVehiclesState()) {
    on<LoadVehicles>(_onLoad);
    on<AddVehicle>(_onAdd);
    on<UpdateVehicle>(_onUpdate);
    on<DeleteVehicle>(_onDelete);
    on<SetPrimaryVehicle>(_onSetPrimary);
  }

  Future<void> _onLoad(LoadVehicles event, Emitter<MyVehiclesState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));

    final vehiclesResult = await repository.getVehicles();
    final categoriesResult = await repository.getSizeCategories();

    vehiclesResult.when(
      onSuccess: (vehicles) => emit(state.copyWith(vehicles: vehicles, isLoading: false)),
      onFailure: (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
    );

    categoriesResult.when(
      onSuccess: (categories) => emit(state.copyWith(sizeCategories: categories)),
      onFailure: (_) {},
    );
  }

  Future<void> _onAdd(AddVehicle event, Emitter<MyVehiclesState> emit) async {
    emit(state.copyWith(isSubmitting: true, failure: null));
    final result = await repository.addVehicle(event.payload);
    result.when(
      onSuccess: (vehicle) {
        final updated = List.of(state.vehicles)..add(vehicle);
        emit(state.copyWith(vehicles: updated, isSubmitting: false));
      },
      onFailure: (failure) => emit(state.copyWith(isSubmitting: false, failure: failure)),
    );
  }

  Future<void> _onUpdate(UpdateVehicle event, Emitter<MyVehiclesState> emit) async {
    emit(state.copyWith(isSubmitting: true, failure: null));
    final result = await repository.updateVehicle(event.id, event.payload);
    result.when(
      onSuccess: (vehicle) {
        final updated = state.vehicles.map((v) => v.id == vehicle.id ? vehicle : v).toList();
        emit(state.copyWith(vehicles: updated, isSubmitting: false));
      },
      onFailure: (failure) => emit(state.copyWith(isSubmitting: false, failure: failure)),
    );
  }

  Future<void> _onDelete(DeleteVehicle event, Emitter<MyVehiclesState> emit) async {
    final result = await repository.deleteVehicle(event.id);
    result.when(
      onSuccess: (_) {
        final updated = state.vehicles.where((v) => v.id != event.id).toList();
        emit(state.copyWith(vehicles: updated));
      },
      onFailure: (failure) => emit(state.copyWith(failure: failure)),
    );
  }

  Future<void> _onSetPrimary(SetPrimaryVehicle event, Emitter<MyVehiclesState> emit) async {
    final result = await repository.setPrimary(event.id);
    result.when(
      onSuccess: (_) async {
        // Re-fetch so exactly one vehicle is flagged as primary, matching the server.
        final vehiclesResult = await repository.getVehicles();
        vehiclesResult.when(
          onSuccess: (vehicles) => emit(state.copyWith(vehicles: vehicles)),
          onFailure: (failure) => emit(state.copyWith(failure: failure)),
        );
      },
      onFailure: (failure) => emit(state.copyWith(failure: failure)),
    );
  }
}
