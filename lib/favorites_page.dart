import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/item_preview.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final favorites = favoritesProvider.favoriteItems;
        
        if (favorites.isEmpty) {
          return Container(
            width: double.infinity,
            color: Colors.grey[50],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No favorites yet!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start adding some items to your favorites',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final item = favorites[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ItemPreview(
                item: item,
                onAddToCart: () {
                  // TODO: Implement add to cart functionality
                },
                onToggleFavorite: () {
                  favoritesProvider.toggleFavorite(item);
                },
                isFavorite: true,
              ),
            );
          },
        );
      },
    );
  }
} 