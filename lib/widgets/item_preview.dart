import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import 'package:flutter/foundation.dart';

class ItemPreview extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onAddToCart;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;

  const ItemPreview({
    Key? key,
    required this.item,
    required this.onAddToCart,
    required this.onToggleFavorite,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemPreviewPage(item: item),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image with favorite overlay
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.imageUrl.startsWith('assets/')
                          ? Image.asset(
                              item.imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.restaurant, size: 32, color: Colors.grey),
                                );
                              },
                            )
                          : Image.network(
                              item.imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.restaurant, size: 32, color: Colors.grey),
                                );
                              },
                            ),
                    ),
                    // Favorite icon overlay (optional, can be removed if not needed)
                  ],
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₹${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating and cart/favorite icons
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      onPressed: onToggleFavorite,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      color: Colors.deepPurple,
                      onPressed: onAddToCart,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemPreviewPage extends StatelessWidget {
  final MenuItem item;

  const ItemPreviewPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Details (left)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    // Nutrition info
                    if (item.calories != null || item.protein != null || item.fat != null || item.carbs != null) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Nutritional Values (per serving)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (item.calories != null) ...[
                            Text('Calories: ', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text('${item.calories!.toStringAsFixed(0)} kcal'),
                            SizedBox(width: 16),
                          ],
                          if (item.protein != null) ...[
                            Text('Protein: ', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text('${item.protein!.toStringAsFixed(1)}g'),
                            SizedBox(width: 16),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          if (item.fat != null) ...[
                            Text('Fat: ', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text('${item.fat!.toStringAsFixed(1)}g'),
                            SizedBox(width: 16),
                          ],
                          if (item.carbs != null) ...[
                            Text('Carbs: ', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text('${item.carbs!.toStringAsFixed(1)}g'),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Large Image (right)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: screenWidth * 0.35,
                  height: screenWidth * 0.35,
                  child: item.imageUrl.startsWith('assets/')
                      ? (kIsWeb
                          ? Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.restaurant, size: 64),
                                );
                              },
                            )
                          : Image.asset(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.restaurant, size: 64),
                                );
                              },
                            ))
                      : Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.restaurant, size: 64),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 