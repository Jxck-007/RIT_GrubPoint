import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/reservation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  // Singleton instance
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Check if Firebase Authentication and Cloud Firestore are available
  Future<bool> checkFirebaseAvailability() async {
    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      
      // Test Firebase Authentication
      await _auth.authStateChanges().first;
      
      // Test Firestore connection
      await _firestore.collection('test').get();
      
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
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  // Save user profile data to Firestore
  Future<void> saveUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).set(data);
    } catch (e) {
      debugPrint('Error saving user data: $e');
      rethrow;
    }
  }

  // Get user profile data from Firestore
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      debugPrint('Error getting user data: $e');
      rethrow;
    }
  }

  Future<void> updateUserData(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      debugPrint('Error updating user data: $e');
      rethrow;
    }
  }

  Future<List<Reservation>> getUserReservations(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Reservation.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting user reservations: $e');
      rethrow;
    }
  }

  Future<void> saveReservation(Reservation reservation) async {
    try {
      await _firestore.collection('reservations').doc(reservation.id).set(reservation.toMap());
    } catch (e) {
      debugPrint('Error saving reservation: $e');
      rethrow;
    }
  }

  Future<void> saveOrder(String userId, Map<String, dynamic> orderData) async {
    try {
      await _firestore.collection('orders').add({
        ...orderData,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving order: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error getting user orders: $e');
      rethrow;
    }
  }

  Future<void> saveReservation(
    String userId,
    Map<String, dynamic> reservationData,
  ) async {
    try {
      await _firestore.collection('reservations').add({
        ...reservationData,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving reservation: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserReservations(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error getting user reservations: $e');
      rethrow;
    }
  }

  Future<void> updateWalletBalance(
    String userId,
    double amount,
    String type,
    String description,
  ) async {
    try {
      final batch = _firestore.batch();
      final userRef = _firestore.collection('users').doc(userId);
      final transactionRef = userRef.collection('transactions').doc();

      batch.update(userRef, {
        'walletBalance': FieldValue.increment(type == 'credit' ? amount : -amount),
      });

      batch.set(transactionRef, {
        'type': type,
        'amount': amount,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      debugPrint('Error updating wallet balance: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getWalletTransactions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error getting wallet transactions: $e');
      rethrow;
    }
  }

  // User Profile Methods
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserTransactions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateWalletBalance(
    String userId,
    double newBalance,
    String type,
    String description,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'walletBalance': newBalance,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveTransaction(
    String userId,
    Map<String, dynamic> transactionData,
  ) async {
    try {
      await _firestore.collection('transactions').add({
        ...transactionData,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Auth Methods
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Storage Methods
  Future<String> uploadImage(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImage(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Query Methods
  Future<QuerySnapshot> getCollection(String collection) async {
    try {
      return await _firestore.collection(collection).get();
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot> getCollectionWhere(
    String collection,
    String field,
    dynamic value,
  ) async {
    try {
      return await _firestore
          .collection(collection)
          .where(field, isEqualTo: value)
          .get();
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot> getCollectionOrderBy(
    String collection,
    String field, {
    bool descending = false,
  }) async {
    try {
      return await _firestore
          .collection(collection)
          .orderBy(field, descending: descending)
          .get();
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot> getCollectionLimit(
    String collection,
    int limit,
  ) async {
    try {
      return await _firestore.collection(collection).limit(limit).get();
    } catch (e) {
      rethrow;
    }
  }

  // Batch Methods
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    try {
      final batch = _firestore.batch();
      for (final operation in operations) {
        final ref = _firestore
            .collection(operation['collection'])
            .doc(operation['document']);
        switch (operation['type']) {
          case 'set':
            batch.set(ref, operation['data']);
            break;
          case 'update':
            batch.update(ref, operation['data']);
            break;
          case 'delete':
            batch.delete(ref);
            break;
        }
      }
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  // Transaction Methods
  Future<void> runTransaction(
    Future<void> Function(Transaction) updateFunction,
  ) async {
    try {
      await _firestore.runTransaction(updateFunction);
    } catch (e) {
      rethrow;
    }
  }
} 