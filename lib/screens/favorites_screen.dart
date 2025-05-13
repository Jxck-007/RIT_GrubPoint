import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/main_scaffold.dart';
import '../widgets/animations.dart';
import '../widgets/item_preview.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favorites, child) {
        return MainScaffold(
          title: 'Favorites',
          body: favorites.favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No favorites yet'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favorites.favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites.favorites[index];
                    return SlideInWidget(
                      begin: Offset(0.0, 0.1 * (index + 1)),
                      child: ScaleInWidget(
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(item.imageUrl),
                                  ),
                                  title: Text(item.name),
                                  subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ItemPreviewPage(item: item),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.favorite, color: Colors.red),
                                        onPressed: () => favorites.toggleFavorite(item),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Provider.of<CartProvider>(context, listen: false).addToCart(item);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${item.name} added to cart'),
                                              duration: const Duration(milliseconds: 500),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.add_shopping_cart),
                                        label: const Text('Add to Cart'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
} 