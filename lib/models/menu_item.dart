import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String fallbackImageUrl;
  final String category;
  final double rating;
  final bool isAvailable;
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbs;
  final Map<String, String> nutritionInfo;
  final String restaurantId;
  final List<String> allergens;
  final Map<String, dynamic> nutritionalInfo;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.fallbackImageUrl,
    required this.category,
    required this.rating,
    this.isAvailable = true,
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
    this.nutritionInfo = const {},
    required this.restaurantId,
    this.allergens = const [],
    this.nutritionalInfo = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'fallbackImageUrl': fallbackImageUrl,
    'category': category,
    'rating': rating,
    'isAvailable': isAvailable,
    'calories': calories,
    'protein': protein,
    'fat': fat,
    'carbs': carbs,
    'nutritionInfo': nutritionInfo,
    'restaurantId': restaurantId,
    'allergens': allergens,
    'nutritionalInfo': nutritionalInfo,
  };

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      fallbackImageUrl: json['fallbackImageUrl'] as String? ?? 'assets/LOGO.png',
      category: json['category'] as String,
      rating: json['rating'] as double,
      isAvailable: json['isAvailable'] as bool? ?? true,
      calories: (json['calories'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
      nutritionInfo: Map<String, String>.from(json['nutritionInfo'] ?? {}),
      restaurantId: json['restaurantId'] as String,
      allergens: List<String>.from(json['allergens'] ?? []),
      nutritionalInfo: Map<String, dynamic>.from(json['nutritionalInfo'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? fallbackImageUrl,
    String? category,
    bool? isAvailable,
    double? rating,
    double? calories,
    double? protein,
    double? fat,
    double? carbs,
    Map<String, String>? nutritionInfo,
    String? restaurantId,
    List<String>? allergens,
    Map<String, dynamic>? nutritionalInfo,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      fallbackImageUrl: fallbackImageUrl ?? this.fallbackImageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
      restaurantId: restaurantId ?? this.restaurantId,
      allergens: allergens ?? this.allergens,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
    );
  }
} 