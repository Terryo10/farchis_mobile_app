import 'package:equatable/equatable.dart';

sealed class ScratchCardEvent extends Equatable {
  const ScratchCardEvent();

  @override
  List<Object?> get props => [];
}

class GetScratchCardsEvent extends ScratchCardEvent {
  const GetScratchCardsEvent();
}

class ScratchCardTriggeredEvent extends ScratchCardEvent {
  final String id;
  const ScratchCardTriggeredEvent(this.id);

  @override
  List<Object?> get props => [id];
}
