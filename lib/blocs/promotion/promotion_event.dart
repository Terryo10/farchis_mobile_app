import 'package:equatable/equatable.dart';

sealed class PromotionEvent extends Equatable {
  const PromotionEvent();

  @override
  List<Object?> get props => [];
}

class GetPromotionsEvent extends PromotionEvent {
  const GetPromotionsEvent();
}
