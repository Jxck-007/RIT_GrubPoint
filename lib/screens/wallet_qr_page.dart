import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rit_grubpoint/providers/auth_provider.dart';
import 'package:rit_grubpoint/providers/wallet_provider.dart';

class WalletQRPage extends StatefulWidget {
  const WalletQRPage({super.key});

  @override
  State<WalletQRPage> createState() => _WalletQRPageState();
}

class _WalletQRPageState extends State<WalletQRPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _generateQRData(String amount, String uid) {
    // Format: amount:uid:timestamp
    return 'amount:$amount:uid:$uid:timestamp:${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Recharge'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter Recharge Amount',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                if (_amountController.text.isNotEmpty && _formKey.currentState?.validate() == true)
                  Center(
                    child: Column(
                      children: [
                        QrImageView(
                          data: _generateQRData(
                            _amountController.text,
                            user?.uid ?? '',
                          ),
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Scan this QR code to recharge ₹${_amountController.text}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => _isLoading = true);
                            try {
                              await walletProvider.recharge(
                                double.parse(_amountController.text),
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Recharge successful'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Generate QR Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 