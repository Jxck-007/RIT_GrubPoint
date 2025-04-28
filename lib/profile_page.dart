import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'screens/notifications_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/reservation_screen.dart';
import 'services/firebase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: "John Doe");
  final TextEditingController _emailController = TextEditingController(text: "student@ritchennai.edu.in");
  final TextEditingController _phoneController = TextEditingController(text: "123-456-7890");
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;
  bool _isFirebaseAvailable = true;
  bool _isEditing = false;

  // Sample order history
  final List<Map<String, String>> _orderHistory = [
    {"date": "2023-04-20", "items": "Margherita Pizza", "total": "\$15.99", "status": "Delivered"},
    {"date": "2023-04-15", "items": "Chicken Burger, Fries", "total": "\$12.49", "status": "Delivered"},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check Firebase availability
      _isFirebaseAvailable = await _firebaseService.checkFirebaseAvailability();

      // Load user data from SharedPreferences first (local storage)
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('user_name');
      if (savedName != null && savedName.isNotEmpty) {
        setState(() {
          _nameController.text = savedName;
        });
      }

      // If Firebase is available, try to load additional data
      if (_isFirebaseAvailable) {
        final user = _firebaseService.getCurrentUser();
        if (user != null) {
          final userData = await _firebaseService.getUserProfile(user.uid);
          if (userData != null) {
            setState(() {
              if (userData['name'] != null) _nameController.text = userData['name'];
              if (userData['email'] != null) _emailController.text = userData['email'];
              if (userData['phone'] != null) _phoneController.text = userData['phone'];
            });
          }
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty'))
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isEditing = false;
    });

    try {
      // Always save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);

      // Save to Firebase if available
      if (_isFirebaseAvailable) {
        final user = _firebaseService.getCurrentUser();
        if (user != null) {
          await _firebaseService.saveUserProfile(user.uid, {
            'name': _nameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'updated_at': DateTime.now().toIso8601String(),
          });
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e'))
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
              tooltip: 'Save Profile',
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              tooltip: 'Edit Profile',
            ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                        _isEditing
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    hintText: 'Enter your name',
                                    border: OutlineInputBorder(),
                                  ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(
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
                          leading: const Icon(Icons.star, color: Colors.amber),
                          title: const Text('My Reviews'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReviewsScreen()),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.calendar_today, color: Colors.green),
                          title: const Text('My Reservations'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReservationScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    "Account Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Account Settings
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person, color: Colors.blue),
                          title: const Text('Change Name'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.green),
                          title: const Text('Contact Information'),
                          subtitle: Text(_phoneController.text),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Show dialog to edit phone number
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Edit Phone Number'),
                                content: TextField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    hintText: 'Enter your phone number',
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _saveProfile();
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Logout'),
                          onTap: _logout,
                        ),
                      ],
                    ),
                  ),
                  
                  // Firebase status indicator
                  if (!_isFirebaseAvailable) ...[
                    const SizedBox(height: 24),
                    Card(
                      color: Colors.orange[100],
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.orange),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Firebase Unavailable',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Some profile features may be limited. Profile data will be saved locally.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
} 