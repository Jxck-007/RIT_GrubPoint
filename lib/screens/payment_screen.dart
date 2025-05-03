import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../services/razorpay_service.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final Function(bool) onPaymentComplete;

  const PaymentScreen({
    Key? key,
    required this.amount,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expMonthController = TextEditingController();
  final _expYearController = TextEditingController();
  final _cvcController = TextEditingController();
  bool _isLoading = false;
  double _swipeProgress = 0.0;
  late RazorpayService _razorpayService;
  String _selectedPaymentMethod = 'razorpay'; // Default to Razorpay

  @override
  void initState() {
    super.initState();
    PaymentService.init();
    _razorpayService = RazorpayService();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expMonthController.dispose();
    _expYearController.dispose();
    _cvcController.dispose();
    _razorpayService.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == 'razorpay') {
      _processRazorpayPayment();
      return;
    }

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final paymentMethod = await PaymentService.createPaymentMethod(
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        expMonth: int.parse(_expMonthController.text),
        expYear: int.parse(_expYearController.text),
        cvc: _cvcController.text,
      );

      // Here you would typically create a payment intent on your backend
      // and then confirm it using the payment method ID
      await Future.delayed(const Duration(seconds: 2));
      
      widget.onPaymentComplete(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
      widget.onPaymentComplete(false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _processRazorpayPayment() {
    setState(() => _isLoading = true);
    
    _razorpayService.initiatePayment(
      amount: widget.amount,
      customerName: "Test Customer", // You should get this from user profile
      customerEmail: "test@example.com", // You should get this from user profile
      customerPhone: "1234567890", // You should get this from user profile
      onSuccess: (String paymentId) {
        setState(() => _isLoading = false);
        widget.onPaymentComplete(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful!')),
        );
      },
      onError: (String error) {
        setState(() => _isLoading = false);
        widget.onPaymentComplete(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $error')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Your Order'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Order Total',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${widget.amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Payment Method Selection
                Card(
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Credit/Debit Card (Stripe)'),
                        value: 'stripe',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Razorpay'),
                        value: 'razorpay',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (_selectedPaymentMethod == 'stripe') ...[
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      hintText: '1234 5678 9012 3456',
                      prefixIcon: const Icon(Icons.credit_card),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expMonthController,
                          decoration: InputDecoration(
                            labelText: 'MM',
                            hintText: '12',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'MM';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _expYearController,
                          decoration: InputDecoration(
                            labelText: 'YY',
                            hintText: '25',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'YY';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _cvcController,
                          decoration: InputDecoration(
                            labelText: 'CVC',
                            hintText: '123',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'CVC';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 32),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _swipeProgress = (_swipeProgress + details.delta.dx / 300).clamp(0.0, 1.0);
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (_swipeProgress >= 0.9) {
                        _processPayment();
                      }
                      setState(() {
                        _swipeProgress = 0.0;
                      });
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: _swipeProgress * MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.arrow_forward, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedPaymentMethod == 'razorpay' 
                                      ? 'Pay with Razorpay' 
                                      : 'Swipe to Pay with Card',
                                  style: TextStyle(
                                    color: _swipeProgress > 0.5 ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
} 