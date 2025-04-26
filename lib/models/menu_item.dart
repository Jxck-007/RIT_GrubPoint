class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String category;
  final bool isAvailable;
  final double rating;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.isAvailable,
    this.rating = 0.0,
  });

  factory MenuItem.fromFirestore(Map<String, dynamic> data, String id) {
    return MenuItem(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imagePath: data['imagePath'] ?? '',
      category: data['category'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'category': category,
      'isAvailable': isAvailable,
      'rating': rating,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'category': category,
      'isAvailable': isAvailable,
      'rating': rating,
    };
  }
} 