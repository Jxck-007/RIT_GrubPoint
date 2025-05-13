import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_item.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<FoodItem>> getFoodItemsByCategory(String category) {
    return _firestore
        .collection('menu')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodItem.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<String>> getCategories() {
    return _firestore
        .collection('menu')
        .snapshots()
        .map((snapshot) {
      final categories = snapshot.docs
          .map((doc) => doc.data()['category'] as String)
          .toSet()
          .toList();
      categories.sort();
      return categories;
    });
  }

  Future<void> addFoodItem(FoodItem item) async {
    await _firestore.collection('menu').doc(item.id).set(item.toJson());
  }

  Future<void> updateFoodItem(FoodItem item) async {
    await _firestore.collection('menu').doc(item.id).update(item.toJson());
  }

  Future<void> deleteFoodItem(String itemId) async {
    await _firestore.collection('menu').doc(itemId).delete();
  }

  Future<FoodItem?> getFoodItem(String itemId) async {
    final doc = await _firestore.collection('menu').doc(itemId).get();
    if (doc.exists) {
      return FoodItem.fromJson(doc.data()!);
    }
    return null;
  }

  Stream<List<FoodItem>> searchFoodItems(String query) {
    return _firestore
        .collection('menu')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodItem.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<FoodItem>> getVegetarianItems() {
    return _firestore
        .collection('menu')
        .where('isVegetarian', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodItem.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<FoodItem>> getVeganItems() {
    return _firestore
        .collection('menu')
        .where('isVegan', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodItem.fromJson(doc.data()))
          .toList();
    });
  }
} 