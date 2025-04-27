import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class MenuProvider with ChangeNotifier {
  String _searchQuery = '';
  String _selectedRestaurant = '';
  double _minPriceFilter = 0.0;
  double _maxPriceFilter = 1000.0;
  bool _showVegOnly = false;
  bool _showNonVegOnly = false;
  double _minRatingFilter = 0.0;
  
  // Sample menu items for now
  final List<MenuItem> _menuItems = [
    MenuItem(
      id: 1,
      name: 'Margherita Pizza',
      description: 'Classic cheese pizza with tomato sauce',
      price: 299,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Pizza',
      rating: 4.5,
    ),
    MenuItem(
      id: 2,
      name: 'Chicken Burger',
      description: 'Grilled chicken burger with lettuce and mayo',
      price: 199,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Burger',
      rating: 4.2,
    ),
    MenuItem(
      id: 3,
      name: 'Caesar Salad',
      description: 'Fresh salad with chicken and caesar dressing',
      price: 149,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Salad',
      rating: 4.0,
    ),
    MenuItem(
      id: 4,
      name: 'Chocolate Milkshake',
      description: 'Rich and creamy chocolate milkshake',
      price: 99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Beverage',
      rating: 4.8,
    ),
    MenuItem(
      id: 5,
      name: 'Veg Biryani',
      description: 'Fragrant rice dish with vegetables and spices',
      price: 249,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Indian',
      rating: 4.6,
    ),
    MenuItem(
      id: 6,
      name: 'Chicken Tikka',
      description: 'Marinated chicken pieces grilled to perfection',
      price: 349,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Indian',
      rating: 4.7,
    ),
  ];
  
  // Getters
  String get searchQuery => _searchQuery;
  String get selectedRestaurant => _selectedRestaurant;
  double get minPriceFilter => _minPriceFilter;
  double get maxPriceFilter => _maxPriceFilter;
  bool get showVegOnly => _showVegOnly;
  bool get showNonVegOnly => _showNonVegOnly;
  double get minRatingFilter => _minRatingFilter;
  
  // Setters with notifications
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void setSelectedRestaurant(String restaurant) {
    _selectedRestaurant = restaurant;
    notifyListeners();
  }
  
  void setPriceRange(double min, double max) {
    _minPriceFilter = min;
    _maxPriceFilter = max;
    notifyListeners();
  }
  
  void setVegFilter(bool value) {
    _showVegOnly = value;
    if (value) {
      _showNonVegOnly = false;
    }
    notifyListeners();
  }
  
  void setNonVegFilter(bool value) {
    _showNonVegOnly = value;
    if (value) {
      _showVegOnly = false;
    }
    notifyListeners();
  }
  
  void setMinRating(double rating) {
    _minRatingFilter = rating;
    notifyListeners();
  }
  
  // Reset all filters
  void resetFilters() {
    _searchQuery = '';
    _minPriceFilter = 0.0;
    _maxPriceFilter = 1000.0;
    _showVegOnly = false;
    _showNonVegOnly = false;
    _minRatingFilter = 0.0;
    notifyListeners();
  }
  
  // Get filtered menu items based on current filters
  List<MenuItem> getFilteredItems() {
    return _menuItems.where((item) {
      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filter by restaurant/category
      final matchesRestaurant = _selectedRestaurant.isEmpty ||
          item.category == _selectedRestaurant;
      
      // Filter by price
      final matchesPrice = item.price >= _minPriceFilter &&
          item.price <= _maxPriceFilter;
      
      // Filter by rating
      final matchesRating = item.rating >= _minRatingFilter;
      
      // Combined filter
      return matchesSearch && 
             matchesRestaurant && 
             matchesPrice && 
             matchesRating;
    }).toList();
  }
  
  // Get all unique restaurant categories
  List<String> get allRestaurants {
    final restaurants = _menuItems.map((item) => item.category).toSet().toList();
    restaurants.sort();
    return restaurants;
  }
} 