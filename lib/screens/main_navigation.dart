import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../home_page.dart';
import '../cart_page.dart';
import '../chat_page.dart';
import '../screens/favorites_screen.dart';
import '../profile_page.dart';
import 'category_items_screen.dart';
import '../services/firebase_service.dart';
<<<<<<< HEAD
import '../favorites_page.dart';
import 'settings_page.dart';
=======
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _isFirebaseAvailable = true;
  
<<<<<<< HEAD
  // Cache pages to prevent rebuilding
  final List<Widget> _pages = [
    const HomePage(),
    const ChatPage(),
    const CartPage(),
    const FavoritesPage(),
=======
  final List<Widget> _pages = [
    const HomePage(),
    const CartPage(),
    const ChatPage(),
    const FavoritesScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Cart',
    'Jarvix Chat',
    'Favorites',
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
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
<<<<<<< HEAD
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
=======
      setState(() {
        _isFirebaseAvailable = isAvailable;
      });
      
      if (!isAvailable && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firebase services are currently unreachable. Please check your internet connection or try again later.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isFirebaseAvailable = false;
      });
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: const Text('RIT GrubPoint'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
=======
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: _selectedIndex == 0 ? AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ) : null,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
<<<<<<< HEAD
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/LOGO.png',
                    height: 80,
                    cacheWidth: 160,
=======
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.deepPurple,
                    ),
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'RIT GrubPoint',
                    style: TextStyle(
<<<<<<< HEAD
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
=======
                      fontSize: 18,
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
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
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
<<<<<<< HEAD
=======
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
            ListTile(
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
<<<<<<< HEAD
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
=======
                // Add settings navigation when available
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon')),
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
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
<<<<<<< HEAD
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
            const Divider(),
            if (!_isFirebaseAvailable)
              const ListTile(
                leading: Icon(Icons.warning, color: Colors.orange),
                title: Text('Firebase Unavailable'),
=======
            const Divider(),
            // Theme toggle switch in drawer only
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
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
                subtitle: Text('Some features may be limited'),
              ),
          ],
        ),
      ),
<<<<<<< HEAD
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
=======
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
          setState(() {
            _selectedIndex = index;
          });
        },
<<<<<<< HEAD
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
=======
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
            label: 'Jarvix',
          ),
          BottomNavigationBarItem(
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
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
<<<<<<< HEAD
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
=======
    
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
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () {
<<<<<<< HEAD
                  Navigator.pop(context);
=======
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryItemsScreen(category: category['name']!),
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
<<<<<<< HEAD
                          boxShadow: [
=======
                          boxShadow: const [
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
<<<<<<< HEAD
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            category['image']!,
                            fit: BoxFit.cover,
=======
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
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name']!,
<<<<<<< HEAD
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
=======
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
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
<<<<<<< HEAD

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About RIT GrubPoint'),
        content: const Text(
          'RIT GrubPoint is a food ordering and delivery app for RIT students. '
          'Order your favorite food from various canteens and restaurants on campus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
=======
  
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
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    );
  }
} 