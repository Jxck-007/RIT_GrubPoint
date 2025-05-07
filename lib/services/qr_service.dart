import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class QRService {
  static Widget generateOrderQR({
    required String orderId,
    required String orderDetails,
    required double size,
  }) {
    final data = {
      'orderId': orderId,
      'orderDetails': orderDetails,
      'timestamp': DateTime.now().toIso8601String(),
    };

    return QrImageView(
      data: jsonEncode(data),
      version: QrVersions.auto,
      size: size,
      backgroundColor: Colors.white,
      errorStateBuilder: (context, error) => Center(
        child: Text(
          'Error generating QR code',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  static Map<String, dynamic>? parseQRData(String data) {
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error parsing QR data: $e');
      return null;
    }
  }

  static bool validateQRData(Map<String, dynamic> data) {
    return data.containsKey('orderId') && 
           data.containsKey('orderDetails') && 
           data.containsKey('timestamp');
  }
} 