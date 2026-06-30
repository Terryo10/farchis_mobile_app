import '../models/payment_method_model.dart';
import 'payment_provider.dart';

/// In-memory payment provider — stores methods in a plain Dart list.
///
/// ═══════════════════════════════════════════════════════════════════════════
/// STUB — NO REAL CHARGES ARE MADE HERE.
/// This provider exists so the UI and [PaymentMethodsBloc] can be built and
/// tested without live API keys.
///
/// SWAP GUIDE (when keys arrive):
///   1. Create  `lib/data/providers/real_payment_provider.dart`
///      implementing [PaymentProvider] and calling the real Paynow / Stripe
///      endpoints (see `ApiConstants.initiatePayment`).
///   2. In `injection.dart`, replace:
///        paymentProvider = LocalPaymentProvider();
///      with:
///        paymentProvider = RealPaymentProvider(httpClient);
///   3. Delete or archive this file.  Everything else stays the same.
/// ═══════════════════════════════════════════════════════════════════════════
class LocalPaymentProvider implements PaymentProvider {
  final List<PaymentMethodModel> _methods = [];

  @override
  Future<List<PaymentMethodModel>> getSavedMethods() async {
    // STUB: returns local list. Real impl → GET /payments/methods
    await Future.delayed(const Duration(milliseconds: 400)); // simulate latency
    return List.unmodifiable(_methods);
  }

  @override
  Future<void> addMethod(PaymentMethodModel method) async {
    // STUB: appends to list. Real impl → POST /payments/methods (tokenise card)
    // API_KEY_STUB: insert payment gateway tokenisation call here.
    _methods.add(method);
  }

  @override
  Future<void> removeMethod(String id) async {
    // STUB: removes from list. Real impl → DELETE /payments/methods/{id}
    _methods.removeWhere((m) => m.id == id);
  }

  @override
  Future<void> setDefault(String id) async {
    // STUB: marks one as default. Real impl → PUT /payments/methods/{id}/default
    for (int i = 0; i < _methods.length; i++) {
      _methods[i] = _methods[i].copyWith(isDefault: _methods[i].id == id);
    }
  }
}
