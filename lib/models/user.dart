import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final List<String> addresses;
  final List<String> favoriteRestaurants;
  final List<String> orderHistory;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isEmailVerified;
  final String? defaultPaymentMethod;
  final List<String> savedPaymentMethods;
  final double walletBalance;
  final Map<String, dynamic>? location;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.addresses = const [],
    this.favoriteRestaurants = const [],
    this.orderHistory = const [],
    this.preferences = const {},
    required this.createdAt,
    this.lastLogin,
    this.isEmailVerified = false,
    this.defaultPaymentMethod,
    this.savedPaymentMethods = const [],
    this.walletBalance = 0.0,
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      addresses: List<String>.from(json['addresses'] ?? []),
      favoriteRestaurants: List<String>.from(json['favoriteRestaurants'] ?? []),
      orderHistory: List<String>.from(json['orderHistory'] ?? []),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastLogin: json['lastLogin'] != null
          ? (json['lastLogin'] as Timestamp).toDate()
          : null,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      defaultPaymentMethod: json['defaultPaymentMethod'] as String?,
      savedPaymentMethods: List<String>.from(json['savedPaymentMethods'] ?? []),
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'addresses': addresses,
      'favoriteRestaurants': favoriteRestaurants,
      'orderHistory': orderHistory,
      'preferences': preferences,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'isEmailVerified': isEmailVerified,
      'defaultPaymentMethod': defaultPaymentMethod,
      'savedPaymentMethods': savedPaymentMethods,
      'walletBalance': walletBalance,
      'location': location,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    List<String>? addresses,
    List<String>? favoriteRestaurants,
    List<String>? orderHistory,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isEmailVerified,
    String? defaultPaymentMethod,
    List<String>? savedPaymentMethods,
    double? walletBalance,
    Map<String, dynamic>? location,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addresses: addresses ?? this.addresses,
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
      orderHistory: orderHistory ?? this.orderHistory,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      savedPaymentMethods: savedPaymentMethods ?? this.savedPaymentMethods,
      walletBalance: walletBalance ?? this.walletBalance,
      location: location ?? this.location,
    );
  }
} 