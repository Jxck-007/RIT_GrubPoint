class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final NutritionalInfo nutritionalInfo;
  final bool isVegetarian;
  final bool isVegan;
  final List<String> allergens;
  final int preparationTime; // in minutes

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.nutritionalInfo,
    required this.isVegetarian,
    required this.isVegan,
    required this.allergens,
    required this.preparationTime,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      category: map['category'] as String,
      nutritionalInfo: NutritionalInfo.fromMap(map['nutritionalInfo'] as Map<String, dynamic>),
      isVegetarian: map['isVegetarian'] as bool,
      isVegan: map['isVegan'] as bool,
      allergens: List<String>.from(map['allergens'] as List),
      preparationTime: map['preparationTime'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'nutritionalInfo': nutritionalInfo.toMap(),
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'allergens': allergens,
      'preparationTime': preparationTime,
    };
  }
}

class NutritionalInfo {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory NutritionalInfo.fromMap(Map<String, dynamic> map) {
    return NutritionalInfo(
      calories: map['calories'] as int,
      protein: map['protein'] as int,
      carbs: map['carbs'] as int,
      fat: map['fat'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
} 