import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/menu_provider.dart';
import '../screens/category_items_screen.dart';
import '../data/menu_data.dart';
import '../home_page.dart';
import '../cart_page.dart';
import '../chat_page.dart';
import '../profile_page.dart';
import '../services/firebase_service.dart';
import '../favorites_page.dart';
import 'settings_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _isFirebaseAvailable = true;
  
  // Cache pages to prevent rebuilding
  final List<Widget> _pages = [
    const HomePage(),
    const CartPage(),
    const ChatPage(),
    const FavoritesPage(),
  ];

  final List<String> _titles = [
    'Home',
    'Cart',
    'Jarvix Chat',
    'Favorites',
  ];

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      final service = FirebaseService();
      final isAvailable = await service.checkFirebaseAvailability();
      if (mounted) {
        setState(() {
          _isFirebaseAvailable = isAvailable;
        });
        
        if (!isAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Firebase services are currently unreachable. Please check your internet connection or try again later.'),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFirebaseAvailable = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
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
                  Text(
                    'Campus Food Delivery',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 12,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () {
                Navigator.pop(context);
                _showCategoriesDialog(context);
              },
            ),
            const Divider(),
            // Theme toggle switch in drawer
            SwitchListTile(
              title: const Text('Dark Mode'),
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
            if (!_isFirebaseAvailable)
              const ListTile(
                leading: Icon(Icons.warning_amber_rounded, color: Colors.orange),
                title: Text('Firebase Unavailable', 
                  style: TextStyle(color: Colors.orange)),
                subtitle: Text('Some features may be limited'),
              ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Jarvix',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  void _showCategoriesDialog(BuildContext context) {
    final categories = [
      {'name': 'Aaharam', 'image': 'assets/shops/aaharam.jpg'},
      {'name': 'Little Rangoon', 'image': 'assets/shops/little_rangoon.jpg'},
      {'name': 'The Pacific Cafe', 'image': 'assets/shops/pacific_cafe.jpg'},
      {'name': 'Cantina de Naples', 'image': 'assets/shops/cantina_de_naples.jpg'},
      {'name': 'Calcutta in a Box', 'image': 'assets/shops/calcutta_in_a_box.jpg'},
    ];
    
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
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryItemsScreen(
                        category: category['name']!,
                        items: demoMenuItems.where((item) => item.category == category['name']).toList(),
                      ),
                    ),
                  );
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              category['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About RIT GrubPoint'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/LOGO.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  'RIT GrubPoint is the official food ordering app for students at Ramaiah Institute of Technology, Chennai.',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Version: 1.0.0',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                const Text(
                  '© 2023 RIT GrubPoint Team',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
} 