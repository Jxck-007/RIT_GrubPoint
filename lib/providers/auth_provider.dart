import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  UserAuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
  }
} 