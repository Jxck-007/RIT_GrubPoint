import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class CartProvider with ChangeNotifier {
  final Map<int, MenuItem> _items = {};

  Map<int, MenuItem> get items => {..._items};
  
  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(MenuItem menuItem) {
    if (_items.containsKey(menuItem.id)) {
      incrementQuantity(menuItem.id);
    } else {
      _items[menuItem.id] = menuItem;
      notifyListeners();
    }
  }

  void removeItem(int id) {
    _items.remove(id);
    notifyListeners();
  }

  void incrementQuantity(int id) {
    if (_items.containsKey(id)) {
      _items[id] = _items[id]!.copyWith(
        quantity: _items[id]!.quantity + 1,
      );
      notifyListeners();
    }
  }

  void decrementQuantity(int id) {
    if (_items.containsKey(id)) {
      if (_items[id]!.quantity > 1) {
        _items[id] = _items[id]!.copyWith(
          quantity: _items[id]!.quantity - 1,
        );
      } else {
        _items.remove(id);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
} 