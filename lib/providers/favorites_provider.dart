import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class FavoritesProvider with ChangeNotifier {
  final List<MenuItem> _favoriteItems = [];

  List<MenuItem> get favoriteItems => _favoriteItems;

  bool isFavorite(MenuItem item) {
    return _favoriteItems.any((favorite) => favorite.id == item.id);
  }

  void addToFavorites(MenuItem item) {
    if (!isFavorite(item)) {
      _favoriteItems.add(item);
      notifyListeners();
    }
  }

  void removeFromFavorites(MenuItem item) {
    _favoriteItems.removeWhere((favorite) => favorite.id == item.id);
    notifyListeners();
  }

  void toggleFavorite(MenuItem item) {
    if (isFavorite(item)) {
      removeFromFavorites(item);
    } else {
      addToFavorites(item);
    }
  }
} 