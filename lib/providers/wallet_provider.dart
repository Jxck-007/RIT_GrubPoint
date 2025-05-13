import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

enum TransactionType {
  credit,
  debit,
}

class Transaction {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final String description;
  final DateTime createdAt;
  final String? orderId;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
    this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'orderId': orderId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      userId: map['userId'] as String,
      amount: map['amount'] as double,
      type: map['type'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      orderId: map['orderId'] as String?,
    );
  }
}

class WalletProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double _balance = 0.0;
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;
  List<Transaction> _transactions = [];

  double get balance => _balance;
  bool get isLoading => _isLoading;
  List<Transaction> get transactions => [..._transactions];

  Future<void> fetchWalletData(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userData = await _firebaseService.getUserProfile(userId);
      if (userData != null) {
        _balance = (userData['walletBalance'] as num?)?.toDouble() ?? 0.0;
      }

      final transactionsData = await _firebaseService.getUserTransactions(userId);
      _transactions = transactionsData.map((data) => Transaction.fromMap(data)).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMoney(String userId, double amount) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newBalance = _balance + amount;
      await _firebaseService.updateWalletBalance(userId, newBalance);
      await _firebaseService.saveTransaction(
        userId,
        {
          'amount': amount,
          'type': 'credit',
          'description': 'Added money to wallet',
        },
      );
      await fetchWalletData(userId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> payForOrder(String userId, double amount, String orderId) async {
    if (_balance < amount) {
      throw Exception('Insufficient balance');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newBalance = _balance - amount;
      await _firebaseService.updateWalletBalance(userId, newBalance);
      await _firebaseService.saveTransaction(
        userId,
        {
          'amount': amount,
          'type': 'debit',
          'description': 'Payment for order',
          'orderId': orderId,
        },
      );
      await fetchWalletData(userId);
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

      await fetchWalletData(_auth.currentUser!.uid);
    } catch (e) {
      debugPrint('Error recharging wallet: $e');
      throw Exception('Failed to recharge wallet: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
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