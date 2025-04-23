import 'package:flutter/material.dart';

class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  // Sample data for orders and stock
  final List<Map<String, dynamic>> orders = [
    {'id': 'ORD001', 'item': 'Veg Noodles', 'status': 'PREPARING'},
    {'id': 'ORD002', 'item': 'Coke', 'status': 'READY'},
    {'id': 'ORD003', 'item': 'Chocolate Cake', 'status': 'DELIVERED'},
  ];
  final Map<String, bool> stock = {
    'Veg Noodles': true,
    'White Sauce Pasta': true,
    'Coke': false,
    'Chocolate Cake': true,
  };

  void _updateOrderStatus(int index) {
    setState(() {
      if (orders[index]['status'] == 'PREPARING') {
        orders[index]['status'] = 'READY';
      } else if (orders[index]['status'] == 'READY') {
        orders[index]['status'] = 'DELIVERED';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${orders[index]['id']} status updated to ${orders[index]['status']}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canteen Staff Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return isWide
              ? Row(
                  children: [
                    Expanded(child: _buildOrdersSection()),
                    VerticalDivider(width: 1, color: Colors.grey[300]),
                    Expanded(child: _buildStockSection()),
                  ],
                )
              : ListView(
                  children: [
                    _buildOrdersSection(),
                    const Divider(height: 32),
                    _buildStockSection(),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildOrdersSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...orders.map((order) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('${order['item']}'),
                  subtitle: Text('Order ID: ${order['id']}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: order['status'] == 'PREPARING'
                          ? Colors.orange
                          : order['status'] == 'READY'
                              ? Colors.green
                              : Colors.grey,
                    ),
                    onPressed: order['status'] == 'DELIVERED'
                        ? null
                        : () => _updateOrderStatus(orders.indexOf(order)),
                    child: Text(order['status']),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStockSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Update Stock', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...stock.entries.map((entry) => SwitchListTile(
                title: Text(entry.key),
                value: entry.value,
                onChanged: (val) {
                  setState(() => stock[entry.key] = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${entry.key} is now ${val ? 'Available' : 'Unavailable'}')),
                  );
                },
                activeColor: Colors.deepPurple,
              )),
        ],
      ),
    );
  }
}
