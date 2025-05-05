import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/menu_provider.dart';
import '../widgets/item_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final filteredItems = menuProvider.getFilteredItems();

    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          final isFavorite = favoritesProvider.isFavorite(item);
          return ItemPreview(
            item: item,
            onAddToCart: () {
              cartProvider.addToCart(item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} added to cart'),
                  duration: const Duration(milliseconds: 500),
                ),
              );
            },
            onToggleFavorite: () => favoritesProvider.toggleFavorite(item),
            isFavorite: isFavorite,
          );
        },
      ),
    );
  }
} 