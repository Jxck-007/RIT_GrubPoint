import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/menu_item.dart';
import 'providers/cart_provider.dart';
import 'screens/menu_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/reservation_screen.dart';
import 'item_preview.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrubPoint'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 100,
              color: Colors.orange,
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to GrubPoint!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your favorite food, delivered.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeMenuPage extends StatefulWidget {
  const HomeMenuPage({super.key});

  @override
  State<HomeMenuPage> createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> {
  int _selectedIndex = 0;
  
  // Sample menu items for now
  final List<MenuItem> _menuItems = [
    MenuItem(
      id: 1,
      name: 'Margherita Pizza',
      description: 'Classic cheese pizza with tomato sauce',
      price: 12.99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Pizza',
      rating: 4.5,
    ),
    MenuItem(
      id: 2,
      name: 'Chicken Burger',
      description: 'Grilled chicken burger with lettuce and mayo',
      price: 8.99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Burger',
      rating: 4.2,
    ),
    MenuItem(
      id: 3,
      name: 'Caesar Salad',
      description: 'Fresh salad with chicken and caesar dressing',
      price: 7.49,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Salad',
      rating: 4.0,
    ),
    MenuItem(
      id: 4,
      name: 'Chocolate Milkshake',
      description: 'Rich and creamy chocolate milkshake',
      price: 4.99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Beverage',
      rating: 4.8,
    ),
  ];

  // Filter categories
  final List<String> _categories = ['All', 'Pizza', 'Burger', 'Salad', 'Beverage'];
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildMenuPage(),
      const CartPage(),
      const ProfilePage(),
      const NotificationsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('RIT GrubPoint'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              setState(() {
                _selectedIndex = 3;
              });
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex < 3 ? _selectedIndex : 0, // Keep bottom nav selection in range
        selectedItemColor: Colors.deepPurple,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: () {
                _showRestaurantOptions(context);
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.more_horiz, color: Colors.white),
            ) 
          : null,
    );
  }

  void _showRestaurantOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('View Menu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MenuScreen(category: 'All'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Make Reservation'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationScreen(
                      restaurantId: 'sample-id',
                      restaurantName: 'Crossroads Cafe',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Reviews'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewsScreen(
                      restaurantId: 'sample-id',
                      restaurantName: 'Crossroads Cafe',
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuPage() {
    // Filter items based on selected category
    final filteredItems = _selectedCategory == 'All'
        ? _menuItems
        : _menuItems.where((item) => item.category == _selectedCategory).toList();

    return Column(
      children: [
        // Category filter chips
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_categories[index]),
                  selected: _selectedCategory == _categories[index],
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = _categories[index];
                    });
                  },
                ),
              );
            },
          ),
        ),
        
        // Menu items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return _buildMenuItem(item);
            },
          ),
        ),
      ],
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
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text('Image not available'),
                  ),
                );
              },
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
                      '\$${item.price.toStringAsFixed(2)}',
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
                            cart.addItem(item);
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

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const MenuItemCard({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final MenuItem item;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  const FoodCard({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: ListTile(
          leading: Semantics(
            label: '${item.name} image',
            child: Image.network(
              item.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant),
                );
              },
            ),
          ),
          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(item.rating.toStringAsFixed(1)),
                ],
              ),
              Text('₹${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            ],
          ),
          trailing: Semantics(
            label: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            button: true,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.deepPurple,
              ),
              onPressed: onFavoriteToggle,
            ),
          ),
        ),
      ),
    );
  }
}

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final List<String> categoryImages;
  final int selectedCategory;
  final ValueChanged<int> onCategorySelected;
  
  const CategorySelector({
    super.key,
    required this.categories,
    required this.categoryImages,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Material(
              color: isSelected ? Colors.deepPurple : Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onCategorySelected(index),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.asset(
                            categoryImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
  }
}

class FoodSearchDelegate extends SearchDelegate<String> {
  final List<MenuItem> menuItems;
  FoodSearchDelegate(this.menuItems);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = menuItems.where((item) =>
        item.name.toLowerCase().contains(query.toLowerCase()) ||
        item.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
    
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: Image.network(
            item.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant),
              );
            },
          ),
          title: Text(item.name),
          subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
          onTap: () async {
            final added = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ItemPreviewPage(item: item),
              ),
            );
            if (added == true) {
              context.read<CartProvider>().addItem(item);
            }
            close(context, item.name);
          },
        );
      },
    );
  }
}

class ProfileTab extends StatelessWidget {
  final Set<String> favoriteItems;
  final String loginMethod;
  const ProfileTab({super.key, required this.favoriteItems, required this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Profile Page', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Text('Logged in with: $loginMethod'),
        const SizedBox(height: 16),
        if (loginMethod == 'email' || loginMethod == 'regNo')
          ElevatedButton(
            onPressed: () async {
              final currentPasswordController = TextEditingController();
              final newPasswordController = TextEditingController();
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Change Password'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: currentPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Current Password'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'New Password'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        try {
                          // Re-authenticate user
                          final cred = EmailAuthProvider.credential(
                            email: user!.email!,
                            password: currentPasswordController.text.trim(),
                          );
                          await user.reauthenticateWithCredential(cred);
                          await user.updatePassword(newPasswordController.text.trim());
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password changed successfully!')),
                          );
                        } catch (e) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                      child: const Text('Change'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Change Password'),
          ),
        const SizedBox(height: 24),
        Text('Favorites', style: Theme.of(context).textTheme.titleMedium),
        ...favoriteItems.isEmpty
            ? [const Text('No favorites yet.')]
            : favoriteItems.map((item) => ListTile(title: Text(item))).toList(),
      ],
    );
  }
}
