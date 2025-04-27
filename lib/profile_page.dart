import 'package:flutter/material.dart';
import 'main.dart';
import 'screens/notifications_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/reservation_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: "John Doe");
  final TextEditingController _emailController = TextEditingController(text: "student@rit.edu");
  final TextEditingController _phoneController = TextEditingController(text: "123-456-7890");

  // Sample order history
  final List<Map<String, String>> _orderHistory = [
    {"date": "2023-04-20", "items": "Margherita Pizza", "total": "\$15.99", "status": "Delivered"},
    {"date": "2023-04-15", "items": "Chicken Burger, Fries", "total": "\$12.49", "status": "Delivered"},
  ];

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully'))
    );
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MyApp()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header with avatar
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  _nameController.text,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _emailController.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text(
            "Settings & Preferences",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick Links
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.deepPurple),
                  title: const Text('Notifications'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  title: const Text('My Reservations'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationScreen(
                          restaurantId: 'my-reservations',
                          restaurantName: 'My Reservations',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star, color: Colors.deepPurple),
                  title: const Text('My Reviews'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewsScreen(
                          restaurantId: 'my-reviews',
                          restaurantName: 'My Reviews',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text(
            "Edit Profile",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Name field
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          
          // Email field
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          
          // Phone field
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: "Phone",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Save Profile"),
            ),
          ),
          
          const SizedBox(height: 32),
          const Text(
            "Order History",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Order history list
          if (_orderHistory.isEmpty)
            const Center(
              child: Text("No orders yet", style: TextStyle(color: Colors.grey)),
            )
          else
            ...List.generate(
              _orderHistory.length,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(_orderHistory[index]["items"]!),
                  subtitle: Text(
                    "${_orderHistory[index]["date"]} - ${_orderHistory[index]["status"]}",
                  ),
                  trailing: Text(
                    _orderHistory[index]["total"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 32),
          // Logout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Logout"),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
} 