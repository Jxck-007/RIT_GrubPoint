import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double _balance = 0.0;

  double get balance => _balance;

  Future<void> loadBalance() async {
    if (_auth.currentUser == null) return;

    final doc = await _firestore
        .collection('wallets')
        .doc(_auth.currentUser!.uid)
        .get();

    if (doc.exists) {
      _balance = (doc.data()?['balance'] ?? 0.0).toDouble();
      notifyListeners();
    }
  }

  Future<void> recharge(double amount) async {
    if (_auth.currentUser == null) return;

    final userRef = _firestore.collection('wallets').doc(_auth.currentUser!.uid);
    
    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(userRef);
      
      if (!doc.exists) {
        transaction.set(userRef, {
          'balance': amount,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        final currentBalance = (doc.data()?['balance'] ?? 0.0).toDouble();
        transaction.update(userRef, {
          'balance': currentBalance + amount,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    });

    await loadBalance();
  }
} 