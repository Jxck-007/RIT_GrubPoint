import 'package:flutter/material.dart';
import 'upi_service.dart';

class PaymentService {
  static Future<bool> processPayment({
    required String amount,
    required String orderId,
    required String description,
    required String merchantName,
    required BuildContext context,
  }) async {
    try {
      final apps = await UPIService.getAvailableApps();
      
      if (apps.isEmpty) {
        throw Exception('No UPI apps found on device');
      }

      // Show UPI app selection dialog
      final selectedApp = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select UPI App'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                return ListTile(
                  leading: Icon(
                    Icons.payment,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(app['name']),
                  onTap: () => Navigator.pop(context, app),
                );
              },
            ),
          ),
        ),
      );

      if (selectedApp == null) {
        return false;
      }

      final success = await UPIService.initiatePayment(
        amount: amount,
        orderId: orderId,
        description: description,
        merchantName: merchantName,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }

      return success;
    } catch (e) {
      debugPrint('Payment Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
} 