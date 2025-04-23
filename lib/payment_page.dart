import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  const PaymentPage({required this.totalAmount, super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedMethod;
  bool _isProcessing = false;

  final List<Map<String, String>> paymentMethods = [
    {'name': 'GPay', 'icon': 'assets/gpay.png'},
    {'name': 'PhonePe', 'icon': 'assets/phonepe.png'},
    {'name': 'Net Banking', 'icon': 'assets/netbanking.png'},
    {'name': 'Cash on Delivery', 'icon': 'assets/cash.png'},
  ];

  void _pay() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate payment
    setState(() => _isProcessing = false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text('Your order has been placed!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Amount: ₹${widget.totalAmount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Select Payment Method:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ...paymentMethods.map((method) => ListTile(
                  leading: method['icon'] != null ? Image.asset(method['icon']!, width: 32, height: 32) : null,
                  title: Text(method['name']!),
                  trailing: Radio<String>(
                    value: method['name']!,
                    groupValue: _selectedMethod,
                    onChanged: (value) => setState(() => _selectedMethod = value),
                  ),
                  onTap: () => setState(() => _selectedMethod = method['name']),
                )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedMethod == null || _isProcessing ? null : _pay,
                child: _isProcessing
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
