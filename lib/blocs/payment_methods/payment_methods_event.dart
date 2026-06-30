import 'package:equatable/equatable.dart';
import '../../data/models/payment_method_model.dart';

sealed class PaymentMethodsEvent extends Equatable {
  const PaymentMethodsEvent();
  @override
  List<Object?> get props => [];
}

class LoadPaymentMethods extends PaymentMethodsEvent {
  const LoadPaymentMethods();
}

class AddPaymentMethod extends PaymentMethodsEvent {
  final PaymentMethodModel method;
  const AddPaymentMethod(this.method);
  @override
  List<Object?> get props => [method];
}

class RemovePaymentMethod extends PaymentMethodsEvent {
  final String id;
  const RemovePaymentMethod(this.id);
  @override
  List<Object?> get props => [id];
}

class SetDefaultPaymentMethod extends PaymentMethodsEvent {
  final String id;
  const SetDefaultPaymentMethod(this.id);
  @override
  List<Object?> get props => [id];
}
