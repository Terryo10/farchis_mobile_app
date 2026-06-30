import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/providers/payment_provider.dart';
import 'payment_methods_event.dart';
import 'payment_methods_state.dart';

class PaymentMethodsBloc extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  final PaymentProvider paymentProvider;

  PaymentMethodsBloc({required this.paymentProvider})
      : super(const PaymentMethodsState()) {
    on<LoadPaymentMethods>(_onLoad);
    on<AddPaymentMethod>(_onAdd);
    on<RemovePaymentMethod>(_onRemove);
    on<SetDefaultPaymentMethod>(_onSetDefault);
  }

  Future<void> _onLoad(
      LoadPaymentMethods event, Emitter<PaymentMethodsState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final methods = await paymentProvider.getSavedMethods();
      emit(state.copyWith(methods: methods, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAdd(
      AddPaymentMethod event, Emitter<PaymentMethodsState> emit) async {
    await paymentProvider.addMethod(event.method);
    final updated = await paymentProvider.getSavedMethods();
    emit(state.copyWith(methods: List.from(updated)));
  }

  Future<void> _onRemove(
      RemovePaymentMethod event, Emitter<PaymentMethodsState> emit) async {
    await paymentProvider.removeMethod(event.id);
    final updated = await paymentProvider.getSavedMethods();
    emit(state.copyWith(methods: List.from(updated)));
  }

  Future<void> _onSetDefault(
      SetDefaultPaymentMethod event, Emitter<PaymentMethodsState> emit) async {
    await paymentProvider.setDefault(event.id);
    final updated = await paymentProvider.getSavedMethods();
    emit(state.copyWith(methods: List.from(updated)));
  }
}
