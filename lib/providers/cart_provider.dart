import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class CartProvider with ChangeNotifier {
  final List<MenuItem> _items = [];
  final Map<int, int> _quantities = {};

  List<MenuItem> get items => _items;

  int get itemCount {
    return _quantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * (_quantities[item.id] ?? 1)));
  }

  int getQuantity(MenuItem item) {
    return _quantities[item.id] ?? 1;
  }

  void addToCart(MenuItem item) {
    if (!_items.contains(item)) {
      _items.add(item);
      _quantities[item.id] = 1;
    } else {
      _quantities[item.id] = (_quantities[item.id] ?? 0) + 1;
    }
    notifyListeners();
  }

  void removeFromCart(MenuItem item) {
    _items.remove(item);
    _quantities.remove(item.id);
    notifyListeners();
  }

  void incrementQuantity(int itemId) {
    if (_quantities.containsKey(itemId)) {
      _quantities[itemId] = (_quantities[itemId] ?? 0) + 1;
      notifyListeners();
    }
  }

  void decrementQuantity(int itemId) {
    if (_quantities.containsKey(itemId)) {
      if (_quantities[itemId]! > 1) {
        _quantities[itemId] = _quantities[itemId]! - 1;
      } else {
        final item = _items.firstWhere((i) => i.id == itemId);
        removeFromCart(item);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _quantities.clear();
    notifyListeners();
  }
} 