import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/product.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => [..._favorites];

  Future<File> get _localFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/favorites.json');
  }

  Future<void> loadFavorites() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final content = await file.readAsString();
        final List data = jsonDecode(content) as List;
        _favorites
          ..clear()
          ..addAll(
              data.map((e) => Product.fromJson(e as Map<String, dynamic>)));
      }
    } catch (e) {
      // ignore and keep empty
    }
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final file = await _localFile;
    await file
        .writeAsString(jsonEncode(_favorites.map((p) => p.toJson()).toList()));
  }

  void toggleFavorite(Product product) async {
    final exists = _favorites.any((item) => item.id == product.id);

    if (exists) {
      _favorites.removeWhere((item) => item.id == product.id);
    } else {
      _favorites.add(product);
    }

    await saveFavorites();
    notifyListeners();
  }

  bool isFavorite(int productId) {
    return _favorites.any((item) => item.id == productId);
  }

  void removeFavorite(int productId) async {
    _favorites.removeWhere((item) => item.id == productId);
    await saveFavorites();
    notifyListeners();
  }

  void clearFavorites() async {
    _favorites.clear();
    await saveFavorites();
    notifyListeners();
  }
}
