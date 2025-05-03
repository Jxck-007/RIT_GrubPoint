import 'package:flutter/material.dart' hide Widget;
import 'package:flutter/widgets.dart' show Widget;
import 'package:provider/provider.dart';
import 'models/menu_item.dart';
import 'providers/cart_provider.dart';
import 'widgets/item_preview.dart';
import 'providers/favorites_provider.dart';
import 'providers/menu_provider.dart';
import 'screens/category_items_screen.dart';
import 'providers/theme_provider.dart';
import 'data/menu_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Food categories
  final List<String> _categories = [
    'All',
    'Lunch',
    'Breakfast',
    'Chaat',
    'Drinks',
    'Snacks'
  ];

  // Canteen data for drawer
  final List<Map<String, dynamic>> _canteens = [
    {
      'name': 'Main Canteen',
      'image': 'assets/shops/aaharam.jpg',
      'menu': [
        {'name': 'Pasta', 'price': 120, 'category': 'Lunch'},
        {'name': 'Sandwich', 'price': 80, 'category': 'Snacks'},
        {'name': 'Tea', 'price': 20, 'category': 'Drinks'},
      ],
    },
    {
      'name': 'Hostel Mess',
      'image': 'assets/shops/calcutta_in_a_box.jpg',
      'menu': [
        {'name': 'Rice Plate', 'price': 60, 'category': 'Lunch'},
        {'name': 'Chapati', 'price': 10, 'category': 'Snacks'},
        {'name': 'Lassi', 'price': 30, 'category': 'Drinks'},
      ],
    },
    {
      'name': 'Juice Bar',
      'image': 'assets/shops/little_rangoon.jpg',
      'menu': [
        {'name': 'Fresh Juice', 'price': 50, 'category': 'Drinks'},
        {'name': 'Fruit Salad', 'price': 70, 'category': 'Snacks'},
        {'name': 'Smoothie', 'price': 90, 'category': 'Drinks'},
      ],
    },
  ];

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Breakfast':
        return Icons.breakfast_dining;
      case 'Chaat':
        return Icons.food_bank;
      case 'Drinks':
        return Icons.local_drink;
      case 'Snacks':
        return Icons.fastfood;
      default:
        return Icons.category;
    }
  }

  void _addToCart(MenuItem item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} added to cart')),
    );
  }

  void _toggleFavorite(MenuItem item) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    favoritesProvider.toggleFavorite(item);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['All', ...getRestaurantNames()];
    final List<MenuItem> menuItems = _selectedCategory == 'All'
        ? demoMenuItems
        : getMenuItemsByRestaurant(_selectedCategory);
    final List<MenuItem> filteredItems = menuItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/LOGO.png',
                    height: 80,
                    cacheWidth: 160,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'RIT GrubPoint',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Select Category'),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      body: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _categories.length - 1, // Exclude 'All'
                        itemBuilder: (context, index) {
                          final category = _categories[index + 1]; // Skip 'All'
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.deepPurple.shade100, width: 2),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        _getCategoryIcon(category),
                                        size: 48,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            ..._canteens.map((canteen) => ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(canteen['image']),
                radius: 20,
              ),
              title: Text(canteen['name']),
              onTap: () {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryItemsScreen(
                        category: canteen['name'],
                        items: canteen['menu'].map<MenuItem>((item) => MenuItem(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: item['name'],
                          description: 'Delicious ${item['name']} from ${canteen['name']}',
                          price: item['price'].toDouble(),
                          imageUrl: 'https://via.placeholder.com/150',
                          category: item['category'],
                          isAvailable: true,
                          rating: 4.5,
                        )).toList(),
                      ),
                    ),
                  );
                });
              },
            )),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search food items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Category filter chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(categories[index]),
                    selected: _selectedCategory == categories[index],
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = categories[index];
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ),
          // Menu items
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text('No items found'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _buildMenuItem(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food image
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Stack(
              children: [
                Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.restaurant, size: 50),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) {
                      final isFavorite = favoritesProvider.isFavorite(item);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => favoritesProvider.toggleFavorite(item),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('${item.rating}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                // Price and add to cart button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return ElevatedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add to Cart'),
                          onPressed: () {
                            cart.addToCart(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 