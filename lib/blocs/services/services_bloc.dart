import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/service_repository.dart';
import 'services_event.dart';
import 'services_state.dart';

/// ServicesBloc manages the list of available services
class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServiceRepository serviceRepository;

  ServicesBloc({required this.serviceRepository}) : super(const ServicesInitial()) {
    on<GetServicesEvent>(_onGetServices);
    on<GetServiceEvent>(_onGetService);
  }

  Future<void> _onGetServices(GetServicesEvent event, Emitter<ServicesState> emit) async {
    emit(const ServicesLoading());

    final result = await serviceRepository.getServices();

    result.when(
      onSuccess: (services) {
        emit(ServicesLoaded(services));
      },
      onFailure: (failure) {
        emit(ServicesLoadFailed(failure));
      },
    );
  }

  Future<void> _onGetService(GetServiceEvent event, Emitter<ServicesState> emit) async {
    emit(const ServiceDetailLoading());

    final result = await serviceRepository.getService(event.id);

    result.when(
      onSuccess: (service) {
        emit(ServiceDetailLoaded(service));
      },
      onFailure: (failure) {
        emit(ServiceDetailLoadFailed(failure));
      },
    );
  }
}
