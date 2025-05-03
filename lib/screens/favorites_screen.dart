import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../models/menu_item.dart';
import '../widgets/item_preview.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favorites, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Favorites'),
          ),
          body: favorites.favorites.isEmpty
              ? const Center(
                  child: Text('No favorites yet'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favorites.favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites.favorites[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(item.imageUrl),
                        ),
                        title: Text(item.name),
                        subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => favorites.toggleFavorite(item),
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