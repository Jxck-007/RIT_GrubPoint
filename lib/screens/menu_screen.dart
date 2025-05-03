import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../widgets/filter_sheet.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';

class MenuScreen extends StatelessWidget {
  final String? category;
  
  const MenuScreen({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menuProvider, child) {
        if (category != null) {
          menuProvider.setSelectedRestaurant(category!);
        }
        final filteredItems = menuProvider.getFilteredItems();
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              menuProvider.selectedRestaurant.isEmpty 
                ? 'All Restaurants' 
                : menuProvider.selectedRestaurant
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const FilterSheet(),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) => menuProvider.setSearchQuery(value),
                  decoration: InputDecoration(
                    hintText: 'Search menu items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),

              // Menu Items List
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Text('No items found'),
                      )
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return MenuItemCard(item: item);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const MenuItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: item.imageUrl.isNotEmpty
                    ? Image.network(
                        item.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.restaurant, size: 40),
                          );
                        },
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant, size: 40),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: item.isAvailable ? null : Colors.grey,
                    ),
                  ),
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: item.rating > 0 ? Colors.amber : Colors.grey,
                      ),
                      Text(
                        ' ${item.rating.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${item.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (!item.isAvailable)
                  const Text(
                    'Not Available',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      cart.addToCart(item);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Added item to cart'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              cart.removeFromCart(item);
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 30),
                    ),
                    child: const Text('Add to Cart'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 