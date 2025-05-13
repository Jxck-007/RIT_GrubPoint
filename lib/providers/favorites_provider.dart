import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class FavoritesProvider with ChangeNotifier {
  final List<MenuItem> _favorites = [];

  List<MenuItem> get favorites => _favorites;

  bool isFavorite(MenuItem item) {
    return _favorites.any((favorite) => favorite.id == item.id);
  }

  void toggleFavorite(MenuItem item) {
    if (isFavorite(item)) {
      _favorites.removeWhere((favorite) => favorite.id == item.id);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }
} 