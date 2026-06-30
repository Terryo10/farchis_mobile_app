import 'package:equatable/equatable.dart';

/// Type of payment method saved by the user.
enum PaymentMethodType { card, ecocash }

/// Represents a saved payment method.
///
/// This model is used exclusively by [LocalPaymentProvider] for in-memory
/// storage. When the real payment API keys arrive, a new concrete
/// [PaymentProvider] will use this same model — no changes needed here.
class PaymentMethodModel extends Equatable {
  final String id; // UUID generated locally
  final PaymentMethodType type;
  /// Human-readable label shown in the list.
  /// For card: "**** **** **** 4242", for EcoCash: "+263 77 123 4567"
  final String displayLabel;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.displayLabel,
    this.isDefault = false,
  });

  PaymentMethodModel copyWith({
    String? id,
    PaymentMethodType? type,
    String? displayLabel,
    bool? isDefault,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      displayLabel: displayLabel ?? this.displayLabel,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, type, displayLabel, isDefault];
}
