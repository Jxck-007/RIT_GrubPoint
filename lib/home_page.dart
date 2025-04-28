import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'models/menu_item.dart';
import 'providers/cart_provider.dart';
import 'item_preview.dart';
import 'providers/favorites_provider.dart';
import 'providers/menu_provider.dart';
import 'screens/category_items_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Category names
  final List<String> _categories = [
    'Lunch',
    'Chaat',
    'Drinks',
    'Snacks',
    'All'
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

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    
    final items = menuProvider.getFilteredItems();
    
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
                        menuItems: canteen['menu'].map((item) => MenuItem(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: item['name'],
                          description: 'Delicious ${item['name']} from ${canteen['name']}',
                          price: item['price'].toDouble(),
                          imageUrl: 'https://via.placeholder.com/150',
                          category: item['category'],
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
          // Search Bar
          Material(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for food...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    menuProvider.setSearchQuery(value);
                  });
                },
              ),
            ),
          ),
          
          // Category Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        if (category == 'All') {
                          menuProvider.setSelectedRestaurant('');
                        } else {
                          menuProvider.setSelectedRestaurant(category);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Menu Items List
          Expanded(
            child: items.isEmpty
                ? Center(
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
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildMenuItem(context, item, cartProvider, favoritesProvider);
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem(
    BuildContext context, 
    MenuItem item, 
    CartProvider cartProvider,
    FavoritesProvider favoritesProvider
  ) {
    final isFavorite = favoritesProvider.isFavorite(item);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant),
                  ),
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