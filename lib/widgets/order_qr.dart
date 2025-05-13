import 'package:flutter/material.dart';
import '../services/qr_service.dart';

class OrderQR extends StatelessWidget {
  final String orderId;
  final String orderDetails;
  final double size;

  const OrderQR({
    Key? key,
    required this.orderId,
    required this.orderDetails,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: QRService.generateOrderQR(
            orderId: orderId,
            orderDetails: orderDetails,
            size: size,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Order #$orderId',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Show this QR code at the canteen',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 