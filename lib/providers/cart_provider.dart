import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class CartProvider with ChangeNotifier {
  final List<MenuItem> _items = [];

  List<MenuItem> get items => _items;

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(MenuItem item) {
    final existingItemIndex = _items.indexWhere((i) => i.id == item.id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(MenuItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void incrementQuantity(int itemId) {
    final itemIndex = _items.indexWhere((i) => i.id == itemId);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(int itemId) {
    final itemIndex = _items.indexWhere((i) => i.id == itemId);
    if (itemIndex >= 0) {
      if (_items[itemIndex].quantity > 1) {
        _items[itemIndex].quantity -= 1;
      } else {
        _items.removeAt(itemIndex);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
} 