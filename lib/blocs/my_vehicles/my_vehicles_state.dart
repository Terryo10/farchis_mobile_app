import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/vehicle_model.dart';

class MyVehiclesState extends Equatable {
  final List<VehicleModel> vehicles;
  final List<VehicleSizeCategoryModel> sizeCategories;
  final bool isLoading;
  final bool isSubmitting;
  final Failure? failure;

  const MyVehiclesState({
    this.vehicles = const [],
    this.sizeCategories = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.failure,
  });

  MyVehiclesState copyWith({
    List<VehicleModel>? vehicles,
    List<VehicleSizeCategoryModel>? sizeCategories,
    bool? isLoading,
    bool? isSubmitting,
    Failure? failure,
  }) {
    return MyVehiclesState(
      vehicles: vehicles ?? this.vehicles,
      sizeCategories: sizeCategories ?? this.sizeCategories,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [vehicles, sizeCategories, isLoading, isSubmitting, failure];
}
