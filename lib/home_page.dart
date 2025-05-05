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
import 'package:flutter/foundation.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Food categories with icons and colors
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.all_inclusive, 'color': Colors.blue},
    {'name': 'Lunch', 'icon': Icons.lunch_dining, 'color': Colors.orange},
    {'name': 'Breakfast', 'icon': Icons.breakfast_dining, 'color': Colors.purple},
    {'name': 'Chaat', 'icon': Icons.food_bank, 'color': Colors.red},
    {'name': 'Drinks', 'icon': Icons.local_drink, 'color': Colors.green},
    {'name': 'Snacks', 'icon': Icons.fastfood, 'color': Colors.amber},
  ];

  // Featured items for carousel
  final List<Map<String, dynamic>> _featuredItems = [
    {
      'name': 'Special Thali',
      'description': 'Complete meal with 3 curries, rice, roti, dal, and dessert',
      'price': 150,
      'image': 'assets/images/special_thali.jpg',
      'fallbackImage': 'assets/LOGO.png',
    },
    {
      'name': 'Chicken Biryani',
      'description': 'Fragrant basmati rice with tender chicken pieces',
      'price': 180,
      'image': 'assets/images/biryani.jpg',
      'fallbackImage': 'assets/LOGO.png',
    },
    {
      'name': 'Mango Lassi',
      'description': 'Sweet yogurt drink with fresh mango pulp',
      'price': 60,
      'image': 'assets/images/mango_lassi.jpg',
      'fallbackImage': 'assets/LOGO.png',
    },
  ];

  // Canteen data for drawer
  final List<Map<String, dynamic>> _canteens = [
    {
      'name': 'Main Canteen',
      'image': 'assets/shops/aaharam.jpg',
      'fallbackImage': 'assets/LOGO.png',
      'menu': [
        {'name': 'Pasta', 'price': 120, 'category': 'Lunch'},
        {'name': 'Sandwich', 'price': 80, 'category': 'Snacks'},
        {'name': 'Tea', 'price': 20, 'category': 'Drinks'},
      ],
    },
    {
      'name': 'Hostel Mess',
      'image': 'assets/shops/calcutta_in_a_box.jpg',
      'fallbackImage': 'assets/LOGO.png',
      'menu': [
        {'name': 'Rice Plate', 'price': 60, 'category': 'Lunch'},
        {'name': 'Chapati', 'price': 10, 'category': 'Snacks'},
        {'name': 'Lassi', 'price': 30, 'category': 'Drinks'},
      ],
    },
    {
      'name': 'Juice Bar',
      'image': 'assets/shops/little_rangoon.jpg',
      'fallbackImage': 'assets/LOGO.png',
      'menu': [
        {'name': 'Fresh Juice', 'price': 50, 'category': 'Drinks'},
        {'name': 'Fruit Salad', 'price': 70, 'category': 'Snacks'},
        {'name': 'Smoothie', 'price': 90, 'category': 'Drinks'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: const SizedBox.shrink(),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to RIT GrubPoint',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your one-stop food ordering app',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Category Chips
          SliverToBoxAdapter(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category['name'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category['icon'],
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : category['color'],
                          ),
                          const SizedBox(width: 4),
                          Text(((category['name'] as String).toLowerCase()).tr()),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category['name'] as String;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: category['color'],
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.black87
                                : Theme.of(context).colorScheme.onSurface),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? category['color'] : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Menu Items List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: filteredItems.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: const Text('No items found'),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = filteredItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.fastfood, size: 32, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.description,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '₹${item.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Consumer<FavoritesProvider>(
                                      builder: (context, favoritesProvider, _) {
                                        final isFavorite = favoritesProvider.isFavorite(item);
                                        return IconButton(
                                          icon: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: isFavorite ? Colors.red : Colors.grey,
                                          ),
                                          iconSize: 22,
                                          onPressed: () => favoritesProvider.toggleFavorite(item),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_shopping_cart),
                                      color: Theme.of(context).colorScheme.primary,
                                      iconSize: 22,
                                      onPressed: () => _addToCart(item),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: filteredItems.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _addToCart(MenuItem item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart(item);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String imagePath, String fallbackPath) {
    try {
      return AssetImage(imagePath);
    } catch (e) {
      return AssetImage(fallbackPath);
    }
  }

  ImageProvider _getShopImageProvider(String imagePath, String fallbackPath) {
    try {
      return AssetImage(imagePath);
    } catch (e) {
      return AssetImage(fallbackPath);
    }
  }
} 