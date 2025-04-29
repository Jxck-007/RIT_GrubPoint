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
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isFavorite = favoritesProvider.isFavorite(item);
          return ItemPreview(
            item: item,
            onAddToCart: () {
              cartProvider.addToCart(item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} added to cart')),
              );
            },
            onToggleFavorite: () {
              if (isFavorite) {
                favoritesProvider.removeFromFavorites(item);
              } else {
                favoritesProvider.addToFavorites(item);
              }
            },
            isFavorite: isFavorite,
          );
        },
      ),
    );
  }
} 