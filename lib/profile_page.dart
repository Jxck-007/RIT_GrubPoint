import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'screens/notifications_screen.dart';
import 'screens/reservation_screen.dart';
import 'services/firebase_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'widgets/main_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  int _totalOrders = 0;
  final TextEditingController _rechargeAmountController = TextEditingController();
  String? _phoneError;

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
    _fetchTotalOrders();
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

  Future<void> _fetchTotalOrders() async {
    try {
      final user = _firebaseService.getCurrentUser();
      if (user != null) {
        final userData = await _firebaseService.getUserProfile(user.uid);
        setState(() {
          _totalOrders = userData?['totalOrders'] ?? 0;
        });
      }
    } catch (e) {
      setState(() {
        _totalOrders = 0;
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

  Future<void> _showLogoutConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRechargeDialog() async {
    _rechargeAmountController.clear();
    String? errorText;
    bool isValidAmount = false;

    await showDialog(
      context: context,
      builder: (context) {
        String upiId = 'kvnk8604@okicici'; // Replace with your UPI ID
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Recharge Wallet'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _rechargeAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter amount',
                      prefixIcon: const Icon(Icons.currency_rupee),
                      errorText: errorText,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          errorText = 'Amount cannot be empty';
                          isValidAmount = false;
                        } else {
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            errorText = 'Please enter a valid amount';
                            isValidAmount = false;
                          } else {
                            errorText = null;
                            isValidAmount = true;
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (isValidAmount)
                    Container(
                      width: 200,
                      height: 200,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: QrImageView(
                        data: 'upi://pay?pa=$upiId&pn=RIT GrubPoint&am=${_rechargeAmountController.text}&cu=INR&tn=Wallet Recharge',
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isValidAmount
                      ? () async {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Recharge request submitted. Admin will approve soon.')),
                          );
                        }
                      : null,
                  child: const Text('I have paid'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _validatePhoneNumber(String phone) {
    if (phone.isEmpty) {
      _phoneError = 'Phone number cannot be empty';
      return false;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      _phoneError = 'Please enter a valid 10-digit phone number';
      return false;
    }
    _phoneError = null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final onBg = Theme.of(context).colorScheme.onSurface;
    return MainScaffold(
      title: 'My Profile',
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

                    // Stats Section
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              context,
                              'Wallet Balance',
                              '₹${_walletBalance?.toStringAsFixed(2) ?? '0.00'}',
                              Icons.account_balance_wallet,
                              Colors.green,
                            ),
                            _buildStatItem(
                              context,
                              'Total Orders',
                              _totalOrders.toString(),
                              Icons.shopping_bag,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

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
                          const Divider(height: 0),
                          ListTile(
                            leading: const Icon(Icons.account_balance_wallet, color: Colors.green),
                            title: const Text('Recharge Wallet'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: _showRechargeDialog,
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
                            leading: const Icon(Icons.phone, color: Colors.orange),
                            title: const Text('Change Phone'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              setState(() {
                                _isEditing = true;
                              });
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Change Phone'),
                                  content: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: 'Phone',
                                      errorText: _phoneError,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _validatePhoneNumber(value);
                                      });
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_validatePhoneNumber(_phoneController.text)) {
                                          _saveProfile();
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Logout Button
                    ElevatedButton.icon(
                      onPressed: _showLogoutConfirmation,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
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
} 