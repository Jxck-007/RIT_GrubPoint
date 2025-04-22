import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StaffLoginPage extends StatefulWidget {
  const StaffLoginPage({super.key});

  @override
  State<StaffLoginPage> createState() => _StaffLoginPageState();
}

class _StaffLoginPageState extends State<StaffLoginPage> {
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      print("Staff signed in: ${FirebaseAuth.instance.currentUser?.displayName}");
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 20),
              const Text('Welcome to Grub Point', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              TextField(
                controller: _regNoController,
                decoration: const InputDecoration(labelText: 'Enter your register number'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _deptController,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print("Staff Login: ${_regNoController.text}, Dept: ${_deptController.text}");
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Sign in with Google"),
                onPressed: _signInWithGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
