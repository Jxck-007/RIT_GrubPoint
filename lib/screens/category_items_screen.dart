import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/menu_item.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/menu_provider.dart';
import '../../item_preview.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String category;
  final List<MenuItem>? menuItems;

  const CategoryItemsScreen({
    Key? key,
    required this.category,
    this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    
    // Set category as selected restaurant to filter items (after build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      menuProvider.setSelectedRestaurant(category);
    });
    
    // Get the filtered items
    final items = menuProvider.getFilteredItems();
    
    // Get category image
    final String categoryImage = _getCategoryImage(category);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(category),
              background: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
                child: Image.asset(
                  categoryImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.no_food,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No items found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return _buildMenuItem(context, item, cartProvider, favoritesProvider);
                },
                childCount: items.length,
              ),
            ),
        ],
      ),
    );
  }

  String _getCategoryImage(String category) {
    final Map<String, String> categoryImages = {
      'Main Canteen': 'assets/shops/main_canteen.jpg',
      'South Indian Canteen': 'assets/shops/south_indian.jpg',
      'North Indian Canteen': 'assets/shops/north_indian.jpg',
      'Lunch': 'assets/shops/lunch.jpg',
      'Chaat': 'assets/shops/chaat.jpg',
      'Drinks': 'assets/shops/drinks.jpg',
      'Snacks': 'assets/shops/snacks.jpg',
    };
    
    return categoryImages[category] ?? 'assets/RITcanteenimage.png';
  }

  Widget _buildMenuItem(
    BuildContext context,
    MenuItem item,
    CartProvider cartProvider,
    FavoritesProvider favoritesProvider,
  ) {
    final isFavorite = favoritesProvider.isFavorite(item);
    
    return Card(
      margin: const EdgeInsets.all(8),
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
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        // Rating
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            Text(' ${item.rating.toStringAsFixed(1)}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        favoritesProvider.removeFromFavorites(item);
                      } else {
                        favoritesProvider.addToFavorites(item);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      cartProvider.addItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name} added to cart'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 