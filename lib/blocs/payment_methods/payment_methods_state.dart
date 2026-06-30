import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/payment_method_model.dart';

class PaymentMethodsState extends Equatable {
  final List<PaymentMethodModel> methods;
  final bool isLoading;
  final Failure? failure;

  const PaymentMethodsState({
    this.methods = const [],
    this.isLoading = false,
    this.failure,
  });

  PaymentMethodsState copyWith({
    List<PaymentMethodModel>? methods,
    bool? isLoading,
    Failure? failure,
  }) {
    return PaymentMethodsState(
      methods: methods ?? this.methods,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [methods, isLoading, failure];
}
