import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Singleton instance
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  // Check if Firebase Authentication and Cloud Firestore are available
  Future<bool> checkFirebaseAvailability() async {
    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      
      // Test Firebase Authentication
      await FirebaseAuth.instance.authStateChanges().first;
      
      // Test Firestore connection
      await FirebaseFirestore.instance.collection('test').get();
      
      return true;
    } catch (e) {
      print('Firebase services error: $e');
      return false;
    }
  }
  
  // Get appropriate error message for Firebase connectivity issues
  String getFirebaseErrorMessage() {
    return 'Firebase services are currently unreachable. Please check your internet connection or try again later.';
  }

  // Get current user from Firebase Auth
  User? getCurrentUser() {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Save user profile data to Firestore
  Future<bool> saveUserProfile(String userId, Map<String, dynamic> userData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(userData, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }

  // Get user profile data from Firestore
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }
<<<<<<< HEAD
  
  // Run a transaction in Firestore
  Future<void> runTransaction(Future<void> Function(Transaction) updateFunction) async {
    try {
      await FirebaseFirestore.instance.runTransaction(updateFunction);
    } catch (e) {
      print('Transaction error: $e');
      throw e;
    }
  }
=======
>>>>>>> 8de4c38708317529c31694d7f9ab862e0bb61141
} 