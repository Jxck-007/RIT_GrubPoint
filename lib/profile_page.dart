import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'screens/notifications_screen.dart';
import 'screens/reservation_screen.dart';
import 'services/firebase_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  double? _walletBalance;
  final TextEditingController _rechargeAmountController = TextEditingController();

  // Sample order history
  final List<Map<String, String>> _orderHistory = [
    {"date": "2023-04-20", "items": "Margherita Pizza", "total": "\$15.99", "status": "Delivered"},
    {"date": "2023-04-15", "items": "Chicken Burger, Fries", "total": "\$12.49", "status": "Delivered"},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchWalletBalance();
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

  Future<void> _fetchWalletBalance() async {
    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        final userData = await _firebaseService.getUserProfile(user.uid);
        setState(() {
          _walletBalance = (userData?['walletBalance'] ?? 0).toDouble();
        });
      }
    } catch (e) {
      setState(() {
        _walletBalance = 0;
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

  Future<void> _showRechargeDialog() async {
    _rechargeAmountController.clear();
    await showDialog(
      context: context,
      builder: (context) {
        String upiId = 'your-upi-id@bank'; // Replace with your UPI ID
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Recharge Wallet'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _rechargeAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter amount',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: 'upi://pay?pa=$upiId&pn=RIT GrubPoint&am=${_rechargeAmountController.text.isEmpty ? '0' : _rechargeAmountController.text}&cu=INR&tn=Wallet Recharge',
                    version: QrVersions.auto,
                    size: 180.0,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // For now, just show a message. Admin approval logic can be added later.
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recharge request submitted. Admin will approve soon.')),
                  );
                },
                child: const Text('I have paid'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _rechargeAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onBg = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar, Name, Email
                    const SizedBox(height: 8),
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, size: 56, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _nameController.text.toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: onBg,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _emailController.text,
                      style: TextStyle(fontSize: 15, color: onBg.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 32),
                    // Settings & Preferences Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Settings & Preferences',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: onBg,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.notifications, color: Colors.deepPurple),
                            title: const Text('Notifications'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.calendar_today, color: Colors.green),
                            title: const Text('My Reservations'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservationScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Account Information Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Account Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: onBg,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Change Name'),
                                  content: TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(labelText: 'Name'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _saveProfile();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Divider(height: 0),
                          ListTile(
                            leading: const Icon(Icons.phone, color: Colors.green),
                            title: const Text('Contact Information'),
                            subtitle: Text(_phoneController.text, style: TextStyle(color: onBg.withOpacity(0.8))),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Wallet Section
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: Colors.amber[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.account_balance_wallet, color: Colors.orange, size: 28),
                                    const SizedBox(width: 8),
                                    const Text('Wallet Balance:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Text(
                                  _walletBalance == null ? 'Loading...' : '₹${_walletBalance!.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.qr_code),
                                label: const Text('Recharge Wallet'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                onPressed: _showRechargeDialog,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 