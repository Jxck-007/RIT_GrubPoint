import '../models/menu_item.dart';
import '../data/menu_data.dart';

class MenuRepository {
  // Get all menu items
  Future<List<MenuItem>> getAllMenuItems() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return demoMenuItems;
  }
  
  // Get menu items by restaurant
  Future<List<MenuItem>> getMenuItemsByRestaurant(String restaurant) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return demoMenuItems.where((item) => item.category == restaurant).toList();
  }
  
  // Get menu items by search query
  Future<List<MenuItem>> searchMenuItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return demoMenuItems.where((item) => 
      item.name.toLowerCase().contains(query.toLowerCase()) ||
      item.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
  
  // Get all unique restaurant names
  Future<List<String>> getRestaurantNames() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return demoMenuItems.map((item) => item.category).toSet().toList();
  }
} 