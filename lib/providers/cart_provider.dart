import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({
    required this.item,
    this.quantity = 1,
  });

  double get totalPrice => item.price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(MenuItem item) {
    if (_items.containsKey(item.id)) {
      _items.update(
        item.id,
        (existingItem) => CartItem(
          item: existingItem.item,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        item.id,
        () => CartItem(item: item),
      );
    }
    notifyListeners();
  }

  void removeFromCart(MenuItem item) {
    _items.remove(item.id);
    notifyListeners();
  }

  void updateQuantity(MenuItem item, int quantity) {
    if (!_items.containsKey(item.id)) return;

    if (quantity <= 0) {
      removeFromCart(item);
    } else {
      _items.update(
        item.id,
        (existingItem) => CartItem(
          item: existingItem.item,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'items': _items.map((key, value) => MapEntry(key, {
        'item': value.item.toJson(),
        'quantity': value.quantity,
      })),
    };
  }

  void loadFromJson(Map<String, dynamic> json) {
    _items.clear();
    final items = json['items'] as Map<String, dynamic>;
    items.forEach((key, value) {
      _items.putIfAbsent(
        key,
        () => CartItem(
          item: MenuItem.fromJson(value['item']),
          quantity: value['quantity'],
        ),
      );
    });
    notifyListeners();
  }
} 