import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../providers/cart_provider.dart';
import '../services/firebase_service.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/loading_animations.dart';
import '../providers/wallet_provider.dart';
import '../widgets/app_drawer.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _upiIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _otpSent = false;
  bool _paymentSuccess = false;
  String _verificationId = '';
  String _selectedPaymentMethod = 'wallet';
  String? _errorMessage;
  double? _walletBalance;
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadBalance();
    });
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        final userData = await _firebaseService.getUserProfile(user.uid);
        if (userData != null) {
          _nameController.text = userData['name'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _walletBalance = (userData['walletBalance'] ?? 0).toDouble();
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _upiIdController.dispose();
    _amountController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> sendOTP() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      String phoneNumber = _phoneController.text;
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+91$phoneNumber';
      }
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            processPaymentAfterOTP();
          } catch (e) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Auto-verification failed: ${e.toString()}';
            });
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Verification failed: ${e.message}';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _otpSent = true;
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP sent to your phone')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error sending OTP: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    }
  }

  Future<void> verifyOTP() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      
      await _auth.signInWithCredential(credential);
      await processPaymentAfterOTP();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> processPaymentAfterOTP() async {
    try {
      final cart = context.read<CartProvider>();
      double amount = double.tryParse(_amountController.text) ?? cart.totalAmount;
      
      if (_selectedPaymentMethod == 'wallet') {
        final walletProvider = context.read<WalletProvider>();
        
        if (walletProvider.balance < amount) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient wallet balance. Please recharge.')),
          );
          setState(() => _isLoading = false);
          return;
        }

        await walletProvider.deduct(amount, paymentDetails: 'RIT GrubPoint Order');
        setState(() => _paymentSuccess = true);
      } else if (_selectedPaymentMethod == 'upi') {
        // Handle UPI payment
        final user = _firebaseService.getCurrentUser();
        if (user == null) throw Exception('User not logged in');
        
        final newBalance = (_walletBalance ?? 0) - amount;
        await _firebaseService.saveUserProfile(user.uid, {'walletBalance': newBalance});
        setState(() => _paymentSuccess = true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_paymentSuccess) {
      return _buildSuccessScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      drawer: const AppDrawer(),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPaymentMethodSelector(),
                const SizedBox(height: 20),
                _buildResponsiveFormLayout(context),
                if (_selectedPaymentMethod == 'upi') ...[
                  const SizedBox(height: 20),
                  _buildUpiQrCode(),
                ],
                const SizedBox(height: 20),
                _buildPaymentButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('Wallet'),
              value: 'wallet',
              groupValue: _selectedPaymentMethod,
              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
            ),
            RadioListTile<String>(
              title: const Text('UPI'),
              value: 'upi',
              groupValue: _selectedPaymentMethod,
              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveFormLayout(BuildContext context) {
    return ResponsiveRowColumn(
      rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
      rowCrossAxisAlignment: CrossAxisAlignment.start,
      rowSpacing: 16,
      columnSpacing: 16,
      layout: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
          ? ResponsiveRowColumnType.ROW
          : ResponsiveRowColumnType.COLUMN,
      children: [
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: _buildNameField(),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: _buildPhoneField(),
        ),
        if (_selectedPaymentMethod == 'upi')
          ResponsiveRowColumnItem(
            rowFlex: 1,
            child: _buildUpiField(),
          ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: _buildAmountField(),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
    );
  }

  Widget _buildUpiField() {
    return TextFormField(
      controller: _upiIdController,
      decoration: const InputDecoration(
        labelText: 'UPI ID',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (_selectedPaymentMethod == 'upi' && (value == null || value.isEmpty)) {
          return 'Please enter your UPI ID';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(
        labelText: 'Amount',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the amount';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  Widget _buildUpiQrCode() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Column(
          children: [
            const Text(
              'Scan QR Code to Pay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: _generateUpiUrl(cart.totalAmount),
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],
        );
      },
    );
  }

  String _generateUpiUrl(double amount) {
    final upiId = _upiIdController.text;
    final name = _nameController.text;
    return 'upi://pay?pa=$upiId&pn=$name&am=$amount&cu=INR&tn=RIT GrubPoint Order';
  }

  Widget _buildPaymentButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : sendOTP,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text(
              'Proceed to Payment',
              style: TextStyle(fontSize: 16),
            ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Paid from: ${_selectedPaymentMethod.toUpperCase()}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
} 