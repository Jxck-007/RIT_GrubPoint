import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/item_preview.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String category;
  final List<MenuItem> items;

  const CategoryItemsScreen({
    required this.category,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isFavorite = favoritesProvider.isFavorite(item);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ItemPreview(
              item: item,
              onAddToCart: () {
                cartProvider.addToCart(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} added to cart')),
                );
              },
              onToggleFavorite: () => favoritesProvider.toggleFavorite(item),
              isFavorite: isFavorite,
            ),
          );
        },
      ),
    );
  }
} 