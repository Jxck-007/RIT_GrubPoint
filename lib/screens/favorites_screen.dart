import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No favorites yet!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding some items to your favorites',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 