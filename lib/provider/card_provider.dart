import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => [..._items];

   
  int get count => _items.length;

  
  void addToCart(Product product) {
     
    if (_items.any((item) => item.id == product.id)) return;

    _items.add(product);
    notifyListeners();
  }

  
  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
 
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  
  bool isInCart(int productId) {
    return _items.any((item) => item.id == productId);
  }
}