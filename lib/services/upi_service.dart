import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UPIService {
  static Future<bool> initiatePayment({
    required String amount,
    required String orderId,
    required String description,
    required String merchantName,
  }) async {
    try {
      // Format the UPI URL
      final upiUrl = Uri.parse(
        'upi://pay?pa=your-merchant-upi-id@bank' // Replace with your UPI ID
        '&pn=$merchantName'
        '&tr=$orderId'
        '&tn=$description'
        '&am=$amount'
        '&cu=INR'
      );

      if (await canLaunchUrl(upiUrl)) {
        return await launchUrl(upiUrl);
      } else {
        throw Exception('Could not launch UPI app');
      }
    } catch (e) {
      debugPrint('UPI Payment Error: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAvailableApps() async {
    // List of common UPI apps
    return [
      {'name': 'Google Pay', 'package': 'com.google.android.apps.nbu.paisa.user'},
      {'name': 'PhonePe', 'package': 'com.phonepe.app'},
      {'name': 'Paytm', 'package': 'net.one97.paytm'},
      {'name': 'Amazon Pay', 'package': 'in.amazon.mShop.android.shopping'},
      {'name': 'BHIM', 'package': 'in.org.npci.upiapp'},
    ];
  }
} 