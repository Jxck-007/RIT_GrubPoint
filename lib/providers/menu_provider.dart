import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';
import '../data/menu_data.dart';

class MenuProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedRestaurant = '';
  double _minPriceFilter = 0.0;
  double _maxPriceFilter = 1000.0;
  bool _showVegOnly = false;
  bool _showNonVegOnly = false;
  double _minRatingFilter = 0.0;
  
  // Use demoMenuItems from menu_data.dart
  List<MenuItem> get _menuItems => demoMenuItems;
  
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
  List<String> getRestaurantCategories() {
    return _menuItems.map((item) => item.category).toSet().toList();
  }
} 