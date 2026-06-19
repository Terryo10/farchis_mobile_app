import 'package:equatable/equatable.dart';

sealed class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

class GetServicesEvent extends ServicesEvent {
  const GetServicesEvent();
}

class GetServiceEvent extends ServicesEvent {
  final String id;

  const GetServiceEvent(this.id);

  @override
  List<Object?> get props => [id];
}
