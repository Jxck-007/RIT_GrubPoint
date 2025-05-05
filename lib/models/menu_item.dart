class MenuItem {
  final int id;
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

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    this.isAvailable = true,
    this.fallbackImageUrl = 'assets/LOGO.png',
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
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
  };

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      imageUrl: json['imageUrl'] as String,
      fallbackImageUrl: json['fallbackImageUrl'] as String? ?? 'assets/LOGO.png',
      category: json['category'] as String,
      rating: json['rating'] as double,
      isAvailable: json['isAvailable'] as bool? ?? true,
      calories: (json['calories'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
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
    int? id,
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
    );
  }
} 