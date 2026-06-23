import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

// Events
sealed class MapsEvent extends Equatable {
  const MapsEvent();
  @override
  List<Object?> get props => [];
}

class RequestLocationPermission extends MapsEvent {}

class UpdateDriverLocation extends MapsEvent {
  final LatLng driverLocation;
  const UpdateDriverLocation(this.driverLocation);
  @override
  List<Object?> get props => [driverLocation];
}

// States
sealed class MapsState extends Equatable {
  const MapsState();
  @override
  List<Object?> get props => [];
}

class MapsInitial extends MapsState {}

class MapsLoading extends MapsState {}

class LocationPermissionGranted extends MapsState {
  final LatLng initialPosition;
  const LocationPermissionGranted(this.initialPosition);
  @override
  List<Object?> get props => [initialPosition];
}

class LocationPermissionDenied extends MapsState {}

class DriverLocationUpdated extends MapsState {
  final LatLng driverLocation;
  const DriverLocationUpdated(this.driverLocation);
  @override
  List<Object?> get props => [driverLocation];
}

// Bloc
class MapsBloc extends Bloc<MapsEvent, MapsState> {
  MapsBloc() : super(MapsInitial()) {
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<UpdateDriverLocation>((event, emit) => emit(DriverLocationUpdated(event.driverLocation)));
  }

  Future<void> _onRequestLocationPermission(RequestLocationPermission event, Emitter<MapsState> emit) async {
    emit(MapsLoading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationPermissionDenied());
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationPermissionDenied());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(LocationPermissionDenied());
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      emit(LocationPermissionGranted(LatLng(position.latitude, position.longitude)));
    } catch (_) {
      emit(LocationPermissionDenied());
    }
  }
}
