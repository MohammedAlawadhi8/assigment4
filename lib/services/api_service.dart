import 'dart:convert';
import 'package:assignment2/models/product.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  static Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse('$_baseUrl/products');
    try {
      final resp = await http.get(uri).timeout(const Duration(seconds: 10));

      if (resp.statusCode == 200) {
        final List data = jsonDecode(resp.body) as List;
        final products = data
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
        return products;
      }
    } catch (_) {}

    return <Product>[];
  }

  static Future<Product> fetchProductById(int id) async {
    final uri = Uri.parse('$_baseUrl/products/$id');
    final resp = await http.get(uri).timeout(const Duration(seconds: 8));

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product: ${resp.statusCode}');
    }
  }

  // Return number of cached products (0 if none)
  // cache removed for simplicity

  static Future<List<String>> fetchCategories() async {
    // try fakestoreapi categories endpoint
    try {
      final uri = Uri.parse('$_baseUrl/products/categories');
      final resp = await http.get(uri).timeout(const Duration(seconds: 8));
      if (resp.statusCode == 200) {
        final List data = jsonDecode(resp.body) as List;
        return data.map((e) => e.toString()).toList();
      }
    } catch (_) {}

    // fallback: derive categories from products
    try {
      final products = await fetchProducts();
      final cats = <String>{};
      for (var p in products) {
        if (p.department != null && p.department!.isNotEmpty)
          cats.add(p.department!);
      }
      return cats.toList();
    } catch (_) {}

    return <String>[];
  }

  // Fetch category info: { 'key': categoryName, 'image': representativeImage }
  static Future<List<Map<String, String>>> fetchCategoryInfo() async {
    final cats = await fetchCategories();
    final List<Map<String, String>> infos = [];

    // simple local mapping for category images — fallback when no product image
    final localMap = <String, String>{
      'electronics': 'assets/images/phone.png',
      'jewelery': 'assets/images/airphone.png',
      "men's clothing": 'assets/images/squeezer.png',
      "women's clothing": 'assets/images/squeezer.png',
    };

    // try to find a representative product image for each category
    try {
      final products = await fetchProducts();
      for (final cat in cats) {
        final key = cat.toLowerCase();
        String image = '';

        // find first product whose department/category matches
        try {
          final match = products.firstWhere(
              (p) => (p.department ?? '').toLowerCase() == key,
              orElse: () => Product(
                  id: -1, name: '', description: '', price: 0.0, imageUrl: ''));
          if (match.id != -1 && match.imageUrl.isNotEmpty) {
            image = match.imageUrl;
          }
        } catch (_) {}

        // fallback to any product whose name contains the category
        if (image.isEmpty) {
          try {
            final match2 = products.firstWhere(
                (p) =>
                    p.name.toLowerCase().contains(key) && p.imageUrl.isNotEmpty,
                orElse: () => Product(
                    id: -1,
                    name: '',
                    description: '',
                    price: 0.0,
                    imageUrl: ''));
            if (match2.id != -1 && match2.imageUrl.isNotEmpty)
              image = match2.imageUrl;
          } catch (_) {}
        }

        // last resort: local asset mapping
        if (image.isEmpty) image = localMap[key] ?? '';

        infos.add({'key': cat, 'image': image});
      }
    } catch (_) {
      // on any failure, fall back to local mapping only
      for (final cat in cats) {
        final key = cat.toLowerCase();
        final image = localMap[key] ?? '';
        infos.add({'key': cat, 'image': image});
      }
    }

    return infos;
  }
}
