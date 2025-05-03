import 'package:stripe_payment/stripe_payment.dart';

class PaymentService {
  static const String publishableKey = 'YOUR_STRIPE_PUBLISHABLE_KEY';
  static const String secretKey = 'YOUR_STRIPE_SECRET_KEY';

  static void init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: publishableKey,
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
  }

  static Future<PaymentMethod> createPaymentMethod({
    required String cardNumber,
    required int expMonth,
    required int expYear,
    required String cvc,
  }) async {
    try {
      PaymentMethod paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(
          card: CreditCard(
            number: cardNumber,
            expMonth: expMonth,
            expYear: expYear,
            cvc: cvc,
          ),
        ),
      );
      return paymentMethod;
    } catch (e) {
      throw Exception('Failed to create payment method: $e');
    }
  }

  static Future<void> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    try {
      await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntentId,
          paymentMethodId: paymentMethodId,
        ),
      );
    } catch (e) {
      throw Exception('Failed to confirm payment: $e');
    }
  }
} 