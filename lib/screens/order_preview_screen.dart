import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';

class OrderPreviewScreen extends StatelessWidget {
  const OrderPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Order Summary')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Thank you for your order!', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
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
                    const Text('Total:', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                    Text('₹${cartProvider.totalAmount.toStringAsFixed(2)}', 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 