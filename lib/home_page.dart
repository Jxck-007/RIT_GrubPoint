import 'package:flutter/material.dart';
import 'package:rit_grubpoint/cart_page.dart';
import 'item_preview.dart';
import 'gemini_chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'models/menu_item.dart';
import 'providers/cart_provider.dart';

class HomeMenuPage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const HomeMenuPage({super.key, this.onToggleTheme});
  @override
  State<HomeMenuPage> createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  final ScrollController _scrollController = ScrollController();
  double _imageOpacity = 1.0;
  double _imageOffset = 0.0;
  bool _isLoading = true;
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;
  final List<String> categories = [
    'Aaharam',
    'Little Rangoon',
    'The pacific Cafe',
    'Cantina de Naples',
    'Calcutta in a Box',
  ];
  final List<String> categoryImages = [
    'assets/Aaharam.png',
    'assets/little Rangoon.png',
    'assets/the pacific cafe.png',
    'assets/Cantina de Naples.png',
    'assets/calcutta in a Box.png',
  ];
  int selectedCategory = 0;
  String searchQuery = '';
  final Set<String> favoriteItems = {};
  String? _error;
  List<MenuItem> _menuItems = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: Curves.easeInOut,
      ),
    );
    _fetchMenuItems();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _imageOpacity = (1 - _scrollController.offset / 200).clamp(0.0, 1.0);
      _imageOffset = _scrollController.offset / 2;
    });
  }

  Future<void> _fetchMenuItems() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final snapshot = await FirebaseFirestore.instance
          .collection('menu_items')
          .where('isAvailable', isEqualTo: true)
          .get();

      final items = snapshot.docs.map((doc) => 
        MenuItem.fromFirestore(doc.data(), doc.id)
      ).toList();

      setState(() {
        _menuItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load menu items. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_selectedTab == 0) {
      body = _isLoading 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: _loadingAnimation,
                    child: const Icon(
                      Icons.restaurant,
                      size: 50,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading Menu...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchMenuItems,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Stack(
                              children: [
                                Transform.translate(
                                  offset: Offset(0, _imageOffset),
                                  child: Opacity(
                                    opacity: _imageOpacity,
                                    child: Image.asset(
                                      'assets/RITcanteenimage.png',
                                      fit: BoxFit.cover,
                                      height: 200,
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
                                        'Your meal, your time \n No lines!',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            CategorySelector(
                              categories: categories,
                              categoryImages: categoryImages,
                              selectedCategory: selectedCategory,
                              onCategorySelected: (index) => setState(() => selectedCategory = index),
                            ),
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, idx) {
                            final filtered = _menuItems.where((item) => item.category == selectedCategory).toList();
                            if (idx >= filtered.length) return null;
                            final item = filtered[idx];
                            return FoodCard(
                              item: item,
                              isFavorite: favoriteItems.contains(item.name),
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
                              },
                              onFavoriteToggle: () {
                                setState(() {
                                  if (favoriteItems.contains(item.name)) {
                                    favoriteItems.remove(item.name);
                                  } else {
                                    favoriteItems.add(item.name);
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
      body = const CartPage();
    } else if (_selectedTab == 2) {
      body = GeminiChatPage();
    } else {
      body = favoriteItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _loadingAnimation,
                    child: const Icon(
                      Icons.favorite_border,
                      size: 100,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final itemName = favoriteItems.elementAt(index);
                final item = _menuItems.firstWhere((item) => item.name == itemName);
                return FoodCard(
                  item: item,
                  isFavorite: true,
                  onTap: () async {
                    setState(() => _isLoading = true);
                    final added = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemPreviewPage(item: item),
                      ),
                    );
                    if (added == true) {
                      context.read<CartProvider>().addItem(item);
                    }
                    setState(() => _isLoading = false);
                  },
                  onFavoriteToggle: () {
                    setState(() => favoriteItems.remove(itemName));
                  },
                );
              },
            );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
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
                delegate: FoodSearchDelegate(_menuItems),
              );
              if (result != null) {
                setState(() => searchQuery = result);
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Student Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile page
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Orders History'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to orders history
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help & support
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to about page
              },
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          setState(() => _selectedTab = index);
        },
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
            label: item.name + ' image',
            child: Image.asset(item.imagePath, width: 48, height: 48),
          ),
          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(item.rating.toString()),
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
          leading: Image.asset(
            item.imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
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
