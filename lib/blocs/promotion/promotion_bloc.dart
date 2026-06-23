import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/promotion_repository.dart';
import 'promotion_event.dart';
import 'promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final PromotionRepository promotionRepository;

  PromotionBloc({required this.promotionRepository}) : super(PromotionInitial()) {
    on<GetPromotionsEvent>(_onGetPromotions);
  }

  Future<void> _onGetPromotions(
      GetPromotionsEvent event, Emitter<PromotionState> emit) async {
    emit(PromotionLoading());
    final result = await promotionRepository.getPromotions();
    result.when(
      onSuccess: (promotions) => emit(PromotionsLoaded(promotions)),
      onFailure: (failure) => emit(PromotionLoadFailed(failure)),
    );
  }
}
