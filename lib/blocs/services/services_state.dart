import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../../data/models/service_model.dart';

sealed class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {
  const ServicesInitial();
}

class ServicesLoading extends ServicesState {
  const ServicesLoading();
}

class ServicesLoaded extends ServicesState {
  final List<ServiceModel> services;

  const ServicesLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class ServicesLoadFailed extends ServicesState {
  final Failure failure;

  const ServicesLoadFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}

class ServiceDetailLoading extends ServicesState {
  const ServiceDetailLoading();
}

class ServiceDetailLoaded extends ServicesState {
  final ServiceModel service;

  const ServiceDetailLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class ServiceDetailLoadFailed extends ServicesState {
  final Failure failure;

  const ServiceDetailLoadFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
