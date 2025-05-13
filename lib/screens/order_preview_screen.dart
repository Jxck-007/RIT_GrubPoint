import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/reservation_service.dart';
import '../widgets/reservation_widget.dart';
import '../widgets/loading_animations.dart';
import 'payment_screen.dart';

class OrderPreviewScreen extends StatefulWidget {
  const OrderPreviewScreen({super.key});

  @override
  State<OrderPreviewScreen> createState() => _OrderPreviewScreenState();
}

class _OrderPreviewScreenState extends State<OrderPreviewScreen> {
  final _reservationService = ReservationService();
  bool _isLoading = false;

  Future<void> _handleReservation(DateTime reservationTime) async {
    setState(() => _isLoading = true);
    try {
      final isAvailable = await _reservationService.isTimeSlotAvailable(reservationTime);
      if (!isAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This time slot is not available. Please choose another time.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      await _reservationService.createReservation(reservationTime);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservation confirmed successfully!'),
            backgroundColor: Colors.green,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Order Summary')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FadeInWidget(
                  child: Text(
                    'Thank you for your order!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                ScaleInWidget(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ShimmerLoading(
                            isLoading: _isLoading,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cartProvider.items.length,
                              itemBuilder: (context, index) {
                                final cartItem = cartProvider.items[index];
                                return ListTile(
                                  title: Text(cartItem.item.name),
                                  subtitle: Text('Quantity: ${cartItem.quantity}'),
                                  trailing: Text('₹${cartItem.totalPrice.toStringAsFixed(2)}'),
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${cartProvider.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInWidget(
                  child: ReservationWidget(
                    onReservationConfirmed: _handleReservation,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaymentScreen(),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: _isLoading
                        ? const LoadingSpinner(color: Colors.white)
                        : const Text(
                            'Proceed to Payment',
                            style: TextStyle(fontSize: 16),
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