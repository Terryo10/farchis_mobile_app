import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/http_client.dart';

class StripePaymentIntent {
  final String clientSecret;
  final String paymentIntentId;
  final String status;

  const StripePaymentIntent({
    required this.clientSecret,
    required this.paymentIntentId,
    required this.status,
  });
}

class PaymentRepository {
  final FarchisHttpClient client;

  PaymentRepository(this.client);

  /// [method] is the user-facing payment method: 'stripe', 'ecocash', or 'paypal'.
  /// EcoCash is routed through the 'paynow' gateway server-side.
  Future<Result<String>> initiatePayment(int bookingId, String method, String phone) async {
    try {
      final gateway = method == 'ecocash' ? 'paynow' : method;
      final body = <String, dynamic>{'booking_id': bookingId, 'gateway': gateway};
      if (method == 'ecocash') {
        body['method'] = 'ecocash';
        body['phone'] = phone;
      }

      final response = await client.post(ApiConstants.initiatePayment, body: body);
      return Result.success(
        response['data']['redirect_url'] ?? response['data']['browserurl'] ?? response['message'],
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Stripe's response shape from `/payments/initiate` is
  /// `{client_secret, payment_intent_id, status}` — distinct from the
  /// redirect-based gateways handled by [initiatePayment], so it gets its
  /// own typed method rather than being squeezed into a `String` result.
  Future<Result<StripePaymentIntent>> initiateStripePayment(int bookingId) async {
    try {
      final response = await client.post(
        ApiConstants.initiatePayment,
        body: {'booking_id': bookingId, 'gateway': 'stripe'},
      );
      final data = response['data'] as Map<String, dynamic>;
      return Result.success(StripePaymentIntent(
        clientSecret: data['client_secret'] as String,
        paymentIntentId: data['payment_intent_id'] as String,
        status: data['status'] as String,
      ));
    } catch (e) {
      return _handleError(e);
    }
  }

  FailureResult<T> _handleError<T>(Object e) {
    if (e is ValidationException) {
      final errors = e.errors.map((key, value) => MapEntry(key, value.toString()));
      return FailureResult<T>(Failure.validation(errors));
    } else if (e is UnauthorizedException) {
      return FailureResult<T>(Failure.unauthorized(e.message));
    } else if (e is NetworkException) {
      return FailureResult<T>(Failure.network(e.message));
    } else if (e is NotFoundException) {
      return FailureResult<T>(Failure.notFound(e.message));
    } else if (e is ServerException) {
      return FailureResult<T>(Failure.server(e.message, statusCode: e.statusCode));
    }
    return FailureResult<T>(Failure.unknown(e.toString()));
  }
}
