import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_user;

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  app_user.User? _userData;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  app_user.User? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        _userData = app_user.User.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      } else {
        // Create new user document if it doesn't exist
        final newUser = app_user.User(
          id: _user!.uid,
          email: _user!.email!,
          displayName: _user!.displayName,
          photoUrl: _user!.photoURL,
          phoneNumber: _user!.phoneNumber,
          createdAt: DateTime.now(),
          isEmailVerified: _user!.emailVerified,
        );
        await _firestore.collection('users').doc(_user!.uid).set(newUser.toJson());
        _userData = newUser;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (displayName != null) {
        await userCredential.user?.updateDisplayName(displayName);
      }

      final newUser = app_user.User(
        id: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        isEmailVerified: false,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set(newUser.toJson());
      _userData = newUser;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      _userData = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    if (_user == null) return;

    try {
      if (displayName != null) {
        await _user!.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await _user!.updatePhotoURL(photoURL);
      }

      if (_userData != null) {
        final updatedUser = _userData!.copyWith(
          displayName: displayName,
          photoUrl: photoURL,
        );
        await _firestore.collection('users').doc(_user!.uid).update(updatedUser.toJson());
        _userData = updatedUser;
      }
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> updateEmail(String newEmail) async {
    if (_user == null) return;

    try {
      await _user!.updateEmail(newEmail);
      if (_userData != null) {
        final updatedUser = _userData!.copyWith(email: newEmail);
        await _firestore.collection('users').doc(_user!.uid).update(updatedUser.toJson());
        _userData = updatedUser;
      }
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> updatePassword(String newPassword) async {
    if (_user == null) return;

    try {
      await _user!.updatePassword(newPassword);
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    if (_user == null) return;

    try {
      await _firestore.collection('users').doc(_user!.uid).delete();
      await _user!.delete();
      _user = null;
      _userData = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }
} 