import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/promotion_model.dart';

sealed class PromotionState extends Equatable {
  const PromotionState();

  @override
  List<Object?> get props => [];
}

class PromotionInitial extends PromotionState {}

class PromotionLoading extends PromotionState {}

class PromotionsLoaded extends PromotionState {
  final List<PromotionModel> promotions;

  const PromotionsLoaded(this.promotions);

  @override
  List<Object?> get props => [promotions];
}

class PromotionLoadFailed extends PromotionState {
  final Failure failure;

  const PromotionLoadFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
