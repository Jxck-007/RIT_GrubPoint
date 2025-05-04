import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_app_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "YOUR_STRIPE_PUBLISHABLE_KEY", // Replace with your Stripe key
        merchantId: "YOUR_MERCHANT_ID", // Optional
        androidPayMode: 'test', // Set to 'production' in release
      ),
    );
  }

  Future<void> _processPayment(double amount) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      
      // Here you would typically send the paymentMethod.id to your backend
      // to complete the payment. For now, we'll just show a success message.
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );
      
      // Clear the cart after successful payment
      if (mounted) {
        Provider.of<CartProvider>(context, listen: false).clearCart();
      }
      
      // Navigate back
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final total = cartProvider.totalAmount;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Payment'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Total Amount: ₹${total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _processPayment(total),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 