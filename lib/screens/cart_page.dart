import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/menu_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final cartItems = cart.items;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Cart'),
          ),
          body: cartItems.isEmpty
              ? const Center(
                  child: Text('Your cart is empty'),
                )
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return _buildCartItem(context, item, cart);
                  },
                ),
          bottomNavigationBar: cartItems.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle checkout
                    },
                    child: const Text('Proceed to Checkout'),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildCartItem(BuildContext context, MenuItem item, CartProvider cart) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(
          item.imageUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 56,
              height: 56,
              color: Colors.grey[300],
              child: const Icon(Icons.restaurant),
            );
          },
        ),
        title: Text(item.name),
        subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => cart.removeItem(item),
        ),
      ),
    );
  }
} 