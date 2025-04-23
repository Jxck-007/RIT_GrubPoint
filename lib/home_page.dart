import 'package:flutter/material.dart';
import 'item_preview.dart';
import 'cart_page.dart';

class HomeMenuPage extends StatefulWidget {
  const HomeMenuPage({super.key});

  @override
  State<HomeMenuPage> createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> {
  int _selectedTab = 0;
  final List<String> categories = ['Noodles', 'Pasta', 'Drink', 'Dessert'];
  final List<String> categoryImages = [
    'assets/noodles.png',
    'assets/pasta.png',
    'assets/sodas.png',
    'assets/dessert.png',
  ];
  int selectedCategory = 0;
  final List<Map<String, dynamic>> cartItems = [];
  String searchQuery = '';

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
    // Add more items as needed
  ];

  Widget _buildBody() {
    switch (_selectedTab) {
      case 0:
        final filteredItems = menuItems.where((item) =>
          item['category'] == selectedCategory &&
          (searchQuery.isEmpty || item['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        ).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedCategory == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurple : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.deepPurple),
                        boxShadow: isSelected
                            ? [BoxShadow(color: Colors.deepPurple.withOpacity(0.1), blurRadius: 8)]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(categoryImages[index], height: 40, width: 40),
                          const SizedBox(height: 8),
                          Text(
                            categories[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return GestureDetector(
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
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.asset(
                                item['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(item['rating'].toString()),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('₹${item['price']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 1:
        return CartPage(cartItems: cartItems);
      case 2:
        return const Center(child: Text('Chat Page'));
      case 3:
        return const ProfileTab();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: FoodSearchDelegate(menuItems, selectedCategory),
              );
              if (result != null) {
                setState(() => searchQuery = result);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              setState(() => _selectedTab = 1);
            },
          ),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: _buildBody(),
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
    );
  }
}

class FoodSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> menuItems;
  final int selectedCategory;
  FoodSearchDelegate(this.menuItems, this.selectedCategory);

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
      item['category'] == selectedCategory &&
      item['name'].toLowerCase().contains(query.toLowerCase())
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
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Page'),
    );
  }
}
