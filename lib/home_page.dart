import 'package:flutter/material.dart';
import 'package:rit_grubpoint/cart_page.dart';
import 'item_preview.dart';
import 'gemini_chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeMenuPage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const HomeMenuPage({super.key, this.onToggleTheme});
  @override
  State<HomeMenuPage> createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> {
  int _selectedTab = 0;
  final List<String> categories = [
    'Noodles',
    'Pasta',
    'Drink',
    'Dessert',
    'Breakfast',
    'Lunch',
    'Our Pick',
  ];
  final List<String> categoryImages = [
    'assets/noodles.png',
    'assets/pasta.png',
    'assets/sodas.png',
    'assets/dessert.png',
    'assets/noodles.png', // Add new images for new categories as needed
    'assets/pasta.png',
    'assets/dessert.png',
  ];
  int selectedCategory = 0;
  final List<Map<String, dynamic>> cartItems = [];
  String searchQuery = '';
  final Set<String> favoriteItems = {};

  final List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Veg Noodles',
      'image': 'assets/noodles.png',
      'rating': 4.5,
      'price': 60,
      'category': 0,
    },
    {
      'name': 'White Sauce Pasta',
      'image': 'assets/pasta.png',
      'rating': 4.2,
      'price': 80,
      'category': 1,
    },
    {
      'name': 'Coke',
      'image': 'assets/sodas.png',
      'rating': 4.0,
      'price': 30,
      'category': 2,
    },
    {
      'name': 'Chocolate Cake',
      'image': 'assets/dessert.png',
      'rating': 4.8,
      'price': 50,
      'category': 3,
    },
    {
      'name': 'Masala Dosa',
      'image': 'assets/noodles.png',
      'rating': 4.7,
      'price': 40,
      'category': 4, // Breakfast
    },
    {
      'name': 'Idli Sambar',
      'image': 'assets/noodles.png',
      'rating': 4.6,
      'price': 30,
      'category': 4, // Breakfast
    },
    {
      'name': 'Paneer Butter Masala',
      'image': 'assets/pasta.png',
      'rating': 4.9,
      'price': 120,
      'category': 5, // Lunch
    },
    {
      'name': 'Veg Biryani',
      'image': 'assets/pasta.png',
      'rating': 4.8,
      'price': 100,
      'category': 5, // Lunch
    },
    {
      'name': 'Exclusive Brownie',
      'image': 'assets/dessert.png',
      'rating': 5.0,
      'price': 70,
      'category': 6, // Our Pick
    },
    {
      'name': 'Exclusive Pizza',
      'image': 'assets/dessert.png',
      'rating': 4.95,
      'price': 150,
      'category': 6, // Our Pick
    },
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_selectedTab == 0) {
      // Home tab: horizontal categories, vertical food list
      body = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Opacity(
                    opacity: 0.18,
                    child: Image.asset(
                      'assets/ritcanteenphoto.png',
                      fit: BoxFit.cover,
                      height: 110,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.fastfood, color: Colors.orange, size: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Provide the best\nfood for you',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Extracted widget for the category selector
            CategorySelector(
              categories: categories,
              categoryImages: categoryImages,
              selectedCategory: selectedCategory,
              onCategorySelected: (index) => setState(() => selectedCategory = index),
            ),
            const SizedBox(height: 8),
            // Food cards with basic tap feedback
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.where((item) => item['category'] == selectedCategory).length,
                itemBuilder: (context, idx) {
                  final filtered = menuItems.where((item) => item['category'] == selectedCategory).toList();
                  final item = filtered[idx];
                  return FoodCard(
                    item: item,
                    isFavorite: favoriteItems.contains(item['name']),
                    onTap: () async {
                      final added = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemPreviewPage(item: item),
                        ),
                      );
                      if (added == true) {
                        setState(() => cartItems.add(item));
                      }
                    },
                    onFavoriteToggle: () {
                      setState(() {
                        if (favoriteItems.contains(item['name'])) {
                          favoriteItems.remove(item['name']);
                        } else {
                          favoriteItems.add(item['name']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else if (_selectedTab == 1) {
      // Cart tab
      body = CartPage(cartItems: cartItems);
    } else if (_selectedTab == 2) {
      body = GeminiChatPage();
    } else {
      // Profile tab (placeholder)
      body = const Center(child: Text('Profile Page'));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: FoodSearchDelegate(menuItems), // Search all items
              );
              if (result != null) {
                setState(() => searchQuery = result);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() => _selectedTab = index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => GeminiChatPage()));
        },
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> item;
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
            label: item['name'] + ' image',
            child: Image.asset(item['image'], width: 48, height: 48),
          ),
          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(item['rating'].toString()),
                ],
              ),
              Text('₹${item['price']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
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
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;
          return Material(
            color: isSelected ? Colors.deepPurple : Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onCategorySelected(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      label: categories[index] + ' category',
                      child: Image.asset(categoryImages[index], height: 32, width: 32),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
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
  final List<Map<String, dynamic>> menuItems;
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
        item['name'].toLowerCase().contains(query.toLowerCase()) ||
        item['category'].toString().toLowerCase().contains(query.toLowerCase())
    ).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: Image.asset(item['image'], width: 40, height: 40),
          title: Text(item['name']),
          subtitle: Text('₹${item['price']}'),
          onTap: () => close(context, item['name']),
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
