import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double _balance = 0.0;
  bool _isLoading = false;

  double get balance => _balance;
  bool get isLoading => _isLoading;

  Future<void> loadBalance() async {
    if (_auth.currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _firestore
          .collection('wallets')
          .doc(_auth.currentUser!.uid)
          .get();

      if (doc.exists) {
        _balance = (doc.data()?['balance'] ?? 0.0).toDouble();
      } else {
        // Initialize wallet if it doesn't exist
        await _firestore.collection('wallets').doc(_auth.currentUser!.uid).set({
          'balance': 0.0,
          'created': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        _balance = 0.0;
      }
    } catch (e) {
      debugPrint('Error loading wallet balance: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recharge(double amount) async {
    if (_auth.currentUser == null) return;
    if (amount <= 0) return;

    _isLoading = true;
    notifyListeners();

    try {
      final userRef = _firestore.collection('wallets').doc(_auth.currentUser!.uid);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userRef);
        
        if (!doc.exists) {
          transaction.set(userRef, {
            'balance': amount,
            'created': FieldValue.serverTimestamp(),
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        } else {
          final currentBalance = (doc.data()?['balance'] ?? 0.0).toDouble();
          transaction.update(userRef, {
            'balance': currentBalance + amount,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }

        // Create transaction record
        final transactionRef = _firestore.collection('transactions').doc();
        transaction.set(transactionRef, {
          'userId': _auth.currentUser!.uid,
          'type': 'recharge',
          'amount': amount,
          'timestamp': FieldValue.serverTimestamp(),
          'transactionId': transactionRef.id,
          'status': 'completed',
        });
      });

      await loadBalance();
    } catch (e) {
      debugPrint('Error recharging wallet: $e');
      throw Exception('Failed to recharge wallet: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deduct(double amount, {String? paymentDetails}) async {
    if (_auth.currentUser == null) return;
    if (amount <= 0) return;

    _isLoading = true;
    notifyListeners();

    try {
      final userRef = _firestore.collection('wallets').doc(_auth.currentUser!.uid);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userRef);
        
        if (!doc.exists) {
          throw Exception('Wallet does not exist');
        }
        
        final currentBalance = (doc.data()?['balance'] ?? 0.0).toDouble();
        if (currentBalance < amount) {
          throw Exception('Insufficient balance');
        }
        
        transaction.update(userRef, {
          'balance': currentBalance - amount,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        // Create payment record
        final paymentRef = _firestore.collection('payments').doc();
        transaction.set(paymentRef, {
          'userId': _auth.currentUser!.uid,
          'amount': amount,
          'paymentMethod': 'wallet',
          'timestamp': FieldValue.serverTimestamp(),
          'paymentId': paymentRef.id,
          'details': paymentDetails,
        });
      });

      await loadBalance();
    } catch (e) {
      debugPrint('Error deducting from wallet: $e');
      throw Exception('Failed to complete payment: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    if (_auth.currentUser == null) return [];

    try {
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get();

      final rechargesSnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .where('type', isEqualTo: 'recharge')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get();

      final List<Map<String, dynamic>> payments = paymentsSnapshot.docs
          .map((doc) => {
                ...doc.data(),
                'type': 'payment',
              })
          .toList();

      final List<Map<String, dynamic>> recharges = rechargesSnapshot.docs
          .map((doc) => doc.data())
          .toList();

      final List<Map<String, dynamic>> allTransactions = [...payments, ...recharges];
      allTransactions.sort((a, b) {
        final aTimestamp = a['timestamp'] as Timestamp?;
        final bTimestamp = b['timestamp'] as Timestamp?;
        if (aTimestamp == null) return 1;
        if (bTimestamp == null) return -1;
        return bTimestamp.compareTo(aTimestamp);
      });

      return allTransactions;
    } catch (e) {
      debugPrint('Error getting transaction history: $e');
      return [];
    }
  }
} 