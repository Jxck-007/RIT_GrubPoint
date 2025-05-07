import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentService {
  late final Razorpay _razorpay;
  late final String _keyId;
  Function(PaymentSuccessResponse)? onPaymentSuccess;
  Function(PaymentFailureResponse)? onPaymentError;
  Function(ExternalWalletResponse)? onExternalWallet;

  RazorpayPaymentService() {
    _keyId = dotenv.env['RAZORPAY_KEY_ID'] ?? '';
    _razorpay = Razorpay();
    _setupEventHandlers();
  }

  void _setupEventHandlers() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      onPaymentSuccess?.call(response);
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      onPaymentError?.call(response);
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      onExternalWallet?.call(response);
    });
  }

  void dispose() {
    _razorpay.clear();
  }

  void openPayment({
    required double amount,
    required String name,
    required String email,
    required String contact,
    String? description,
  }) {
    var options = {
      'key': _keyId,
      'amount': (amount * 100).toInt(), // Amount in smallest currency unit
      'name': 'RIT GrubPoint',
      'description': description ?? 'Food Order Payment',
      'prefill': {
        'contact': contact,
        'email': email,
        'name': name,
      },
      'external': {
        'wallets': ['paytm', 'gpay', 'phonepe']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }
} 