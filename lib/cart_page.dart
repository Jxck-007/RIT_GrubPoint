import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'models/menu_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add some items to get started',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items.values.toList()[index];
                    return CartItemCard(item: item);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery Fee:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          cart.totalAmount > 0 ? '\$2.00' : '\$0.00',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
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
                          '\$${(cart.totalAmount + (cart.totalAmount > 0 ? 2.0 : 0.0)).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout functionality coming soon!'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cart cleared'),
                          ),
                        );
                      },
                      child: const Text('Clear Cart'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final MenuItem item;

  const CartItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Item image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant, color: Colors.white),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Subtotal: \$${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity controls
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        cart.decrementQuantity(item.id);
                      },
                    ),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        cart.incrementQuantity(item.id);
                      },
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Remove'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    cart.removeItem(item.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
