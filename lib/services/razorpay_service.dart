import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static const String keyId = 'rzp_test_1DP5mmOlF5G5ag'; // Test key for development
  late Razorpay _razorpay;
  late Function(String) _onSuccess;
  late Function(String) _onError;
  bool _isInitialized = false;

  RazorpayService() {
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    try {
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize Razorpay: $e');
      _isInitialized = false;
    }
  }

  void initiatePayment({
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) {
    if (!_isInitialized) {
      onError('Payment service not initialized. Please try again.');
      return;
    }

    _onSuccess = onSuccess;
    _onError = onError;

    if (amount <= 0) {
      onError('Invalid amount');
      return;
    }

    var options = {
      'key': keyId,
      'amount': (amount * 100).toInt(), // Amount in paise
      'name': 'RIT GrubPoint',
      'description': 'Food Order Payment',
      'prefill': {
        'name': customerName,
        'email': customerEmail,
        'contact': customerPhone,
      },
      'external': {
        'wallets': ['paytm']
      },
      'theme': {
        'color': '#FF4081',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
      _onError('Error: ${e.toString()}');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    _onSuccess(response.paymentId ?? '');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.message}');
    _onError(response.message ?? 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
  }

  void dispose() {
    if (_isInitialized) {
      _razorpay.clear();
    }
  }
} 