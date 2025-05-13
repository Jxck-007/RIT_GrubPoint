import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Breakfast',
        'icon': Icons.breakfast_dining,
        'color': Colors.orange,
        'description': 'Start your day with our delicious breakfast options',
      },
      {
        'name': 'Lunch',
        'icon': Icons.lunch_dining,
        'color': Colors.green,
        'description': 'Satisfy your hunger with our lunch specials',
      },
      {
        'name': 'Dinner',
        'icon': Icons.dinner_dining,
        'color': Colors.purple,
        'description': 'End your day with our dinner menu',
      },
      {
        'name': 'Snacks',
        'icon': Icons.cake,
        'color': Colors.pink,
        'description': 'Quick bites and snacks for any time',
      },
      {
        'name': 'Beverages',
        'icon': Icons.local_drink,
        'color': Colors.blue,
        'description': 'Refreshing drinks and beverages',
      },
      {
        'name': 'Desserts',
        'icon': Icons.icecream,
        'color': Colors.red,
        'description': 'Sweet treats to satisfy your cravings',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/category-items',
                  arguments: category['name'],
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: category['color'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category['name'] as String,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category['description'] as String,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.primary,
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