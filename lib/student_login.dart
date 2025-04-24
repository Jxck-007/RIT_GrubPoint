import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key});

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final TextEditingController _regNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedYear;

  Future<void> _loginWithRegNo() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      print('Current user before Firestore write: \\${user?.uid}');
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'regNo': _regNoController.text,
          'year': _selectedYear,
          'role': 'student',
          'loginMethod': 'regNo',
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print('Firestore write complete for user: \\${user.uid}');
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeMenuPage()),
          );
          print('Navigated to HomePage.');
        }
      } else {
        print('User is null after login!');
      }
      print('Current user after login: \\${FirebaseAuth.instance.currentUser}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),

      );
    } catch (e) {
      print('Error in _loginWithRegNo: \\${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithRedirect(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'role': 'student',
            'loginMethod': 'google',
            'lastLogin': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          // Pop the login page to let StreamBuilder in main.dart handle navigation
          if (mounted) Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeMenuPage()),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Signed in successfully!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          message = 'Account exists with a different sign-in method.';
          break;
        case 'invalid-credential':
          message = 'Invalid credentials. Please try again.';
          break;
        case 'user-disabled':
          message = 'This user has been disabled.';
          break;
        case 'user-not-found':
          message = 'No user found for this account.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset('assets/LOGO.png', height: 100),
                ),
                const SizedBox(height: 20),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 500),
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                  child: const Text('Welcome to Grub Point'),
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: DropdownButtonFormField<String>(
                    key: ValueKey(_selectedYear),
                    value: _selectedYear,
                    decoration: const InputDecoration(labelText: 'Year'),
                    items: ['1st Year', '2nd Year', '3rd Year', '4th Year']
                        .map((year) => DropdownMenuItem(value: year, child: Text(year)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedYear = value),
                    validator: (value) => value == null ? 'Please select your year' : null,
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: TextFormField(
                    controller: _regNoController,
                    keyboardType: TextInputType.number,
                    maxLength: 13,
                    decoration: const InputDecoration(
                      labelText: 'Enter your register number',
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Register number is required';
                      }
                      if (value.length > 13) {
                        return 'Cannot exceed 13 digits';
                      }
                      if (!RegExp(r'^\d{1,13}$').hasMatch(value)) {
                        return 'Only numbers allowed';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedScale(
                  scale: _isLoading ? 0.9 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginWithRegNo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: _isLoading ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text("Sign in with Google"),
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      side: const BorderSide(color: Colors.deepPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
