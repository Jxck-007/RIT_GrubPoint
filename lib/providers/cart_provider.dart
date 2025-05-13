import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});

  double get totalPrice => item.price * quantity;

  Map<String, dynamic> toJson() => {
    'item': item.toJson(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      item: MenuItem.fromJson(json['item']),
      quantity: json['quantity'],
    );
  }
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  static const String _cartKey = 'cart_items';

  CartProvider() {
    _loadCart();
  }

  List<CartItem> get items => [..._items];

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        final List<dynamic> decoded = json.decode(cartJson);
        _items.clear();
        _items.addAll(decoded.map((item) => CartItem.fromJson(item)));
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(_items.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  void addToCart(MenuItem item) {
    final existingIndex = _items.indexWhere((cartItem) => cartItem.item.id == item.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
    notifyListeners();
    _saveCart();
  }

  void removeFromCart(MenuItem item) {
    _items.removeWhere((cartItem) => cartItem.item.id == item.id);
    notifyListeners();
    _saveCart();
  }

  void updateQuantity(MenuItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(item);
      return;
    }

    final existingIndex = _items.indexWhere((cartItem) => cartItem.item.id == item.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity = newQuantity;
      notifyListeners();
      _saveCart();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }
} 