import '../models/payment_method_model.dart';

/// Abstract interface for the payment-method wallet.
///
/// Swap points:
/// ─────────────────────────────────────────────────────────────────────────
/// When the real payment API keys arrive:
///   1. Create `RealPaymentProvider implements PaymentProvider`.
///   2. Inject it in place of [LocalPaymentProvider] inside `injection.dart`.
///   3. The UI and BLoC never need to change.
/// ─────────────────────────────────────────────────────────────────────────
abstract class PaymentProvider {
  /// Returns all saved payment methods for the current user.
  Future<List<PaymentMethodModel>> getSavedMethods();

  /// Persists a new payment method.
  Future<void> addMethod(PaymentMethodModel method);

  /// Removes the method identified by [id].
  Future<void> removeMethod(String id);

  /// Marks the method identified by [id] as the default, un-marking all others.
  Future<void> setDefault(String id);
}
