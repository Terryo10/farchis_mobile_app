import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/scratch_card_model.dart';

sealed class ScratchCardState extends Equatable {
  const ScratchCardState();

  @override
  List<Object?> get props => [];
}

class ScratchCardInitial extends ScratchCardState {}

class ScratchCardsLoading extends ScratchCardState {}

class ScratchCardsLoaded extends ScratchCardState {
  final List<ScratchCardModel> cards;
  const ScratchCardsLoaded(this.cards);

  @override
  List<Object?> get props => [cards];
}

class ScratchCardScratchSuccess extends ScratchCardState {
  final ScratchCardModel card;
  const ScratchCardScratchSuccess(this.card);

  @override
  List<Object?> get props => [card];
}

class ScratchCardError extends ScratchCardState {
  final Failure failure;
  const ScratchCardError(this.failure);

  @override
  List<Object?> get props => [failure];
}
