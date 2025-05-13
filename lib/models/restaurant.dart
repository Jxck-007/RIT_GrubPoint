import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final double rating;
  final List<String> categories;
  final Map<String, dynamic> hours;
  final bool isOpen;
  final String phoneNumber;
  final String email;
  final Map<String, dynamic> location;
  final List<String> paymentMethods;
  final double deliveryFee;
  final int deliveryTime;
  final double minimumOrder;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    this.rating = 0.0,
    this.categories = const [],
    this.hours = const {},
    this.isOpen = true,
    required this.phoneNumber,
    required this.email,
    this.location = const {},
    this.paymentMethods = const [],
    this.deliveryFee = 0.0,
    this.deliveryTime = 30,
    this.minimumOrder = 0.0,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      categories: List<String>.from(json['categories'] ?? []),
      hours: Map<String, dynamic>.from(json['hours'] ?? {}),
      isOpen: json['isOpen'] as bool? ?? true,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      location: Map<String, dynamic>.from(json['location'] ?? {}),
      paymentMethods: List<String>.from(json['paymentMethods'] ?? []),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      deliveryTime: json['deliveryTime'] as int? ?? 30,
      minimumOrder: (json['minimumOrder'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'address': address,
      'rating': rating,
      'categories': categories,
      'hours': hours,
      'isOpen': isOpen,
      'phoneNumber': phoneNumber,
      'email': email,
      'location': location,
      'paymentMethods': paymentMethods,
      'deliveryFee': deliveryFee,
      'deliveryTime': deliveryTime,
      'minimumOrder': minimumOrder,
    };
  }

  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? address,
    double? rating,
    List<String>? categories,
    Map<String, dynamic>? hours,
    bool? isOpen,
    String? phoneNumber,
    String? email,
    Map<String, dynamic>? location,
    List<String>? paymentMethods,
    double? deliveryFee,
    int? deliveryTime,
    double? minimumOrder,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      categories: categories ?? this.categories,
      hours: hours ?? this.hours,
      isOpen: isOpen ?? this.isOpen,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      location: location ?? this.location,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      minimumOrder: minimumOrder ?? this.minimumOrder,
    );
  }
} 