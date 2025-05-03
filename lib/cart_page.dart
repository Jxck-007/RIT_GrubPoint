import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'models/menu_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          body: cart.items.isEmpty
              ? const Center(
                  child: Text('Your cart is empty'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(item.imageUrl),
                        ),
                        title: Text(item.name),
                        subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => cart.removeFromCart(item),
                        ),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: cart.items.isEmpty
              ? null
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total: ₹${cart.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement checkout
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout functionality coming soon!'),
                            ),
                          );
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
} 