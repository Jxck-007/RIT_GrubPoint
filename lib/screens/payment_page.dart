import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/payment_service.dart';
import '../services/firebase_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String _selectedPaymentMethod = 'wallet';
  double? _walletBalance;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    final user = _firebaseService.getCurrentUser();
    if (user != null) {
      final userData = await _firebaseService.getUserProfile(user.uid);
      setState(() {
        _walletBalance = (userData?['walletBalance'] ?? 0).toDouble();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required details')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cart = context.read<CartProvider>();
      final amount = cart.totalAmount;
      if (_selectedPaymentMethod == 'wallet') {
        final user = _firebaseService.getCurrentUser();
        if (user == null) throw Exception('User not logged in');
        if ((_walletBalance ?? 0) < amount) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient wallet balance. Please recharge.')),
          );
          setState(() => _isLoading = false);
          return;
        }
        // Deduct from wallet
        final newBalance = (_walletBalance ?? 0) - amount;
        await _firebaseService.saveUserProfile(user.uid, {'walletBalance': newBalance});
        setState(() => _walletBalance = newBalance);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful via Wallet!'), backgroundColor: Colors.green),
        );
        context.read<CartProvider>().clearCart();
        if (mounted) Navigator.of(context).pop();
        return;
      } else {
        final success = await PaymentService.processPayment(
          amount: amount.toString(),
          orderId: DateTime.now().millisecondsSinceEpoch.toString(),
          description: 'RIT GrubPoint Order - ${cart.items.length} items',
          merchantName: 'RIT GrubPoint',
          context: context,
        );
        if (success) {
          context.read<CartProvider>().clearCart();
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Payment'),
            backgroundColor: Colors.green,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Items:'),
                            Text('${cart.itemCount}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹${cart.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Text('Select Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Radio<String>(
                      value: 'wallet',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                    ),
                    const Text('Wallet'),
                    if (_walletBalance != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text('₹${_walletBalance!.toStringAsFixed(2)}', style: TextStyle(color: Colors.orange)),
                      ),
                    Radio<String>(
                      value: 'upi',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                    ),
                    const Text('UPI'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Pay Now',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 