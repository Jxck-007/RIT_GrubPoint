import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/menu_item.dart';
import 'order_preview_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final items = cartProvider.items;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
            actions: [
              if (items.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Cart'),
                        content: const Text('Are you sure you want to clear your cart?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              cartProvider.clearCart();
                              Navigator.pop(context);
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          body: items.isEmpty
              ? const Center(
                  child: Text('Your cart is empty'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          
                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) {
                              cartProvider.removeItem(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item.name} removed from cart'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 4,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: FittedBox(
                                        child: Text('₹${item.price}'),
                                      ),
                                    ),
                                  ),
                                  title: Text(item.name),
                                  subtitle: Text('Total: ₹${(item.price * item.quantity)}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          cartProvider.decrementQuantity(item.id);
                                        },
                                      ),
                                      Text('${item.quantity}'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          cartProvider.incrementQuantity(item.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(15),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            Chip(
                              label: Text(
                                '₹${cartProvider.totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            TextButton(
                              onPressed: items.isEmpty ? null : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderPreviewScreen(
                                      orderItems: List<MenuItem>.from(items),
                                      total: cartProvider.totalAmount,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('ORDER NOW'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
} 