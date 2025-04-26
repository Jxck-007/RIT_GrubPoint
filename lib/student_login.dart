import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentLoginPage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const StudentLoginPage({super.key, this.onToggleTheme});
  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _regNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedYear = '2024';
  bool _isLoading = false;

  @override
  void dispose() {
    _regNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        
        if (userCredential.user != null) {
          await _updateUserData(userCredential.user!);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Login failed: ${e.toString()}');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginWithRegNo() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final regNo = _regNoController.text.trim();
        final email = '$regNo@rit.edu';
        final password = 'RIT${regNo}'; // Default password format

        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        if (userCredential.user != null) {
          await _updateUserData(userCredential.user!);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Login failed: ${e.toString()}');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _updateUserData(userCredential.user!);
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Google sign in failed: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserData(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'role': 'student',
      'year': _selectedYear,
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Grub Point'),
        actions: widget.onToggleTheme != null
            ? [
                IconButton(
                  icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
                  onPressed: widget.onToggleTheme,
                  tooltip: 'Toggle Theme',
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Choose Login Method', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // Registration Number Login
              Card(
                child: ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text('Registration Number'),
                  subtitle: const Text('Login with your RIT registration number'),
                  onTap: () => _showRegNoLogin(),
                ),
              ),
              const SizedBox(height: 10),
              
              // Email/Password Login
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email & Password'),
                  subtitle: const Text('Login with your email and password'),
                  onTap: () => _showEmailLogin(),
                ),
              ),
              const SizedBox(height: 10),
              
              // Google Login
              Card(
                child: ListTile(
                  leading: const Icon(Icons.g_mobiledata),
                  title: const Text('Google Sign In'),
                  subtitle: const Text('Login with your Google account'),
                  onTap: _signInWithGoogle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRegNoLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Number Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _regNoController,
              decoration: const InputDecoration(labelText: 'Registration Number'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter your registration number' : null,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedYear,
              items: ['2024', '2023', '2022', '2021'].map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedYear = value!),
              decoration: const InputDecoration(labelText: 'Year'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loginWithRegNo();
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showEmailLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => value?.isEmpty ?? true ? 'Please enter your password' : null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loginWithEmail();
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
