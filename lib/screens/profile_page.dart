import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: "John Doe");
  final TextEditingController _emailController = TextEditingController(text: "john.doe@example.com");
  final TextEditingController _phoneController = TextEditingController(text: "123-456-7890");

  final List<Map<String, String>> _orderHistory = [
    {"date": "2025-04-20", "items": "Pizza, Coke", "total": "\$20", "status": "Delivered"},
    {"date": "2025-04-18", "items": "Burger, Fries", "total": "\$15", "status": "Delivered"},
  ];

  final List<Map<String, String>> _paymentMethods = [
    {"type": "Visa **** 1234", "details": "12/23"},
    {"type": "PayPal", "details": "john.doe@example.com"},
  ];

  void _saveProfile() {
    // Add save profile logic here
    print("Profile updated: ${_nameController.text}, ${_emailController.text}, ${_phoneController.text}");
  }

  void _logout() {
    // Add logout logic here
    print("User logged out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Edit Profile", 
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold
                )),
            const SizedBox(height: 16),
            
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Save Changes"),
            ),
            const Divider(height: 32),

            Text("Order History", 
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold
                )),
            const SizedBox(height: 8),
            ..._orderHistory.map((order) => Card(
              child: ListTile(
                title: Text(order["items"]!),
                subtitle: Text("${order["date"]} - ${order["status"]}"),
                trailing: Text(order["total"]!),
              ),
            )).toList(),
            const Divider(height: 32),

            Text("Payment Methods", 
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold
                )),
            const SizedBox(height: 8),
            ..._paymentMethods.map((method) => Card(
              child: ListTile(
                title: Text(method["type"]!),
                subtitle: Text(method["details"]!),
              ),
            )).toList(),
            const Divider(height: 32),

            Center(
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text("Logout"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
