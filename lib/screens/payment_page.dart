import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
<<<<<<< HEAD
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
=======
import '../providers/cart_provider.dart';
import '../services/payment_service.dart';
import '../services/firebase_service.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/loading_animations.dart';
>>>>>>> 8de4c38708317529c31694d7f9ab862e0bb61141

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _nameController = TextEditingController();
<<<<<<< HEAD
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
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
=======
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String _selectedPaymentMethod = 'wallet';
  double? _walletBalance;
  final FirebaseService _firebaseService = FirebaseService();
>>>>>>> 8de4c38708317529c31694d7f9ab862e0bb61141

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
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
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      setState(() => _isLoading = false);
=======
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    final user = _firebaseService.getCurrentUser();
    if (user != null) {
      final userData = await _firebaseService.getUserProfile(user.uid);
      setState(() {
        _walletBalance = (userData?['walletBalance'] ?? 0).toDouble();
      });
>>>>>>> 8de4c38708317529c31694d7f9ab862e0bb61141
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
<<<<<<< HEAD
    _phoneController.dispose();
    _upiIdController.dispose();
    _amountController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Format phone number to international format if needed
      String phoneNumber = _phoneController.text;
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+91$phoneNumber'; // Adding India code by default
      }
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android
          try {
            await _auth.signInWithCredential(credential);
            _processPaymentAfterOTP();
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
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout for auto-retrieval
        },
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

  Future<void> _verifyOTP() async {
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
      await _processPaymentAfterOTP();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processPaymentAfterOTP() async {
    try {
      final cart = context.read<CartProvider>();
      double amount = double.tryParse(_amountController.text) ?? cart.totalAmount;
      
      if (_selectedPaymentMethod == 'wallet') {
        final walletProvider = context.read<WalletProvider>();
        
        if (walletProvider.balance < amount) {
=======
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

    // Validate Gmail address
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Gmail address'),
          backgroundColor: Colors.red,
        ),
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
>>>>>>> 8de4c38708317529c31694d7f9ab862e0bb61141
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient wallet balance. Please recharge.')),
          );
          setState(() => _isLoading = false);
          return;
        }
<<<<<<< HEAD
        
        // Deduct from wallet using wallet provider
        await walletProvider.deduct(amount, paymentDetails: 'RIT GrubPoint Order');
        
        // Clear cart
        context.read<CartProvider>().clearCart();
        
        setState(() {
          _paymentSuccess = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
      setState(() => _isLoading = false);
=======
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
>>>>>>> 8de4c38708317529c31694d7f9ab862e0bb61141
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final walletProvider = context.watch<WalletProvider>();
    final cart = context.watch<CartProvider>();
    
    if (_paymentSuccess) {
      return _buildSuccessScreen();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.green,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                  ),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Items:'),
                            Text('${cart.itemCount}'),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Details',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        if (!_otpSent) ...[
                          _buildResponsiveFormLayout(context),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'wallet',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                              ),
                              const Text('Wallet'),
                              const SizedBox(width: 5),
                              Text(
                                '₹${walletProvider.balance.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.green),
                              ),
                              const SizedBox(width: 20),
                              Radio<String>(
                                value: 'upi',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                              ),
                              const Text('UPI'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _sendOTP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Proceed to Pay',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                            ),
                          ),
                          if (_selectedPaymentMethod == 'upi') ...[
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 10),
                            const Text(
                              'Or pay using QR Code',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: QrImageView(
                                data: _generateUpiUrl(cart.totalAmount),
                                version: QrVersions.auto,
                                size: 200,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Center(
                              child: Text(
                                'UPI ID: kvnk8607@okicici',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ] else ...[
                          const Text(
                            'Enter OTP',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: _otpController,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                              activeColor: Colors.green,
                              inactiveColor: Colors.grey,
                              selectedColor: Colors.green,
                            ),
                            cursorColor: Colors.black,
                            animationDuration: const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            keyboardType: TextInputType.number,
                            onCompleted: (v) {
                              debugPrint("Completed");
                            },
                            beforeTextPaste: (text) {
                              return true;
                            },
                            onChanged: (String value) {},
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _verifyOTP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Verify & Pay',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _otpSent = false;
                              });
                            },
                            child: const Text('Back to Payment Details'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveFormLayout(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).largerThan(MOBILE)) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildNameField()),
              const SizedBox(width: 16),
              Expanded(child: _buildPhoneField()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildUpiField()),
              const SizedBox(width: 16),
              Expanded(child: _buildAmountField()),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildNameField(),
          const SizedBox(height: 16),
          _buildPhoneField(),
          const SizedBox(height: 16),
          _buildUpiField(),
          const SizedBox(height: 16),
          _buildAmountField(),
        ],
      );
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
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
        prefixIcon: Icon(Icons.phone),
        hintText: '10-digit mobile number',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter phone number';
        }
        // Validate phone number (10 digits)
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Enter valid 10-digit mobile number';
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
        prefixIcon: Icon(Icons.account_balance),
        hintText: 'username@bank',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) {
        if (_selectedPaymentMethod == 'upi') {
          if (value == null || value.isEmpty) {
            return 'Please enter UPI ID';
          }
          // Validate UPI ID format (username@bank)
          if (!RegExp(r'^[a-zA-Z0-9_.]+@[a-zA-Z0-9]+$').hasMatch(value)) {
            return 'Enter valid UPI ID (username@bank)';
          }
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    final cart = context.read<CartProvider>();
    _amountController.text = cart.totalAmount.toString();
    
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(
        labelText: 'Amount',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.currency_rupee),
        prefixText: '₹ ',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter amount';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Enter a valid positive amount';
        }
        return null;
      },
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
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
              'Amount: ₹${_amountController.text}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Paid from: ${_selectedPaymentMethod.toUpperCase()}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateUpiUrl(double amount) {
    return 'upi://pay?pa=kvnk8607@okicici&pn=RITGrubPoint&am=$amount&cu=INR&tn=Payment';
=======
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: const ResponsiveText(
              'Payment',
              mobileStyle: TextStyle(fontSize: 20),
              tabletStyle: TextStyle(fontSize: 24),
              desktopStyle: TextStyle(fontSize: 28),
            ),
            backgroundColor: Colors.green,
          ),
          body: SingleChildScrollView(
            child: ResponsivePadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FadeInWidget(
                    child: ResponsiveText(
                      'Payment Details',
                      mobileStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      tabletStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      desktopStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ScaleInWidget(
                    child: Card(
                      elevation: 4,
                      child: ResponsivePadding(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ResponsiveText(
                              'Order Summary',
                              mobileStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              tabletStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              desktopStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  ),
                  const SizedBox(height: 20),
                  ResponsiveLayout(
                    mobile: Column(
                      children: _buildFormFields(),
                    ),
                    tablet: Row(
                      children: [
                        Expanded(child: _buildFormFields()[0]),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFormFields()[1]),
                      ],
                    ),
                    desktop: Row(
                      children: [
                        Expanded(child: _buildFormFields()[0]),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFormFields()[1]),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFormFields()[2]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ResponsiveText(
                    'Select Payment Method:',
                    mobileStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabletStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    desktopStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                    height: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 60 : 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const LoadingSpinner(color: Colors.white)
                          : const ResponsiveText(
                              'Pay Now',
                              mobileStyle: TextStyle(fontSize: 16, color: Colors.white),
                              tabletStyle: TextStyle(fontSize: 18, color: Colors.white),
                              desktopStyle: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildFormFields() {
    return [
      TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Full Name',
          border: OutlineInputBorder(),
        ),
      ),
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Gmail Address',
          border: const OutlineInputBorder(),
          helperText: 'Only Gmail addresses are accepted',
          errorText: _emailController.text.isNotEmpty && 
                    !RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(_emailController.text)
                    ? 'Please enter a valid Gmail address'
                    : null,
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {}); // Trigger rebuild to show/hide error
        },
      ),
      TextField(
        controller: _phoneController,
        decoration: const InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone,
      ),
    ];
>>>>>>> 8de4c38708317529c31694d7f9ab862e0bb61141
  }
} 