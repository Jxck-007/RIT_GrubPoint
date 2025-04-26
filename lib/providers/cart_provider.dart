import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.price * quantity;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(MenuItem menuItem) {
    final existingIndex = _items.indexWhere((item) => item.menuItem.id == menuItem.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(menuItem: menuItem));
    }
    notifyListeners();
  }

  void removeItem(MenuItem menuItem) {
    _items.removeWhere((item) => item.menuItem.id == menuItem.id);
    notifyListeners();
  }

  void increaseQuantity(MenuItem menuItem) {
    final index = _items.indexWhere((item) => item.menuItem.id == menuItem.id);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(MenuItem menuItem) {
    final index = _items.indexWhere((item) => item.menuItem.id == menuItem.id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  int getItemQuantity(MenuItem menuItem) {
    final index = _items.indexWhere((item) => item.menuItem.id == menuItem.id);
    return index >= 0 ? _items[index].quantity : 0;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
} 