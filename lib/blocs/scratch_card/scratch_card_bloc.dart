import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/scratch_card_repository.dart';
import 'scratch_card_event.dart';
import 'scratch_card_state.dart';

class ScratchCardBloc extends Bloc<ScratchCardEvent, ScratchCardState> {
  final ScratchCardRepository scratchCardRepository;

  ScratchCardBloc({required this.scratchCardRepository}) : super(ScratchCardInitial()) {
    on<GetScratchCardsEvent>(_onGetScratchCards);
    on<ScratchCardTriggeredEvent>(_onScratchCardTriggered);
  }

  Future<void> _onGetScratchCards(
      GetScratchCardsEvent event, Emitter<ScratchCardState> emit) async {
    emit(ScratchCardsLoading());
    final result = await scratchCardRepository.getScratchCards();
    result.when(
      onSuccess: (cards) => emit(ScratchCardsLoaded(cards)),
      onFailure: (failure) => emit(ScratchCardError(failure)),
    );
  }

  Future<void> _onScratchCardTriggered(
      ScratchCardTriggeredEvent event, Emitter<ScratchCardState> emit) async {
    emit(ScratchCardsLoading());
    final result = await scratchCardRepository.scratchCard(event.id);
    result.when(
      onSuccess: (card) => emit(ScratchCardScratchSuccess(card)),
      onFailure: (failure) => emit(ScratchCardError(failure)),
    );
  }
}
