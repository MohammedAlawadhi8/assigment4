import 'dart:convert';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String? department;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.department,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // support different APIs: 'title' or 'name', 'category' or 'department', 'image' or 'imageUrl'
    final idVal = json['id'];
    final id = idVal is int ? idVal : int.parse(idVal.toString());
    final name = (json['name'] ?? json['title'] ?? '') as String;
    final description = (json['description'] ?? '') as String;
    final priceNum = json['price'] ?? 0;
    final price = (priceNum is num)
        ? priceNum.toDouble()
        : double.tryParse(priceNum.toString()) ?? 0.0;
    String imageUrl = '';
    if (json.containsKey('image') &&
        (json['image'] ?? '').toString().isNotEmpty) {
      imageUrl = json['image'].toString();
    } else if (json.containsKey('imageUrl') &&
        (json['imageUrl'] ?? '').toString().isNotEmpty) {
      imageUrl = json['imageUrl'].toString();
    } else if (json.containsKey('thumbnail') &&
        (json['thumbnail'] ?? '').toString().isNotEmpty) {
      imageUrl = json['thumbnail'].toString();
    } else if (json.containsKey('images') &&
        json['images'] is List &&
        (json['images'] as List).isNotEmpty) {
      final first = (json['images'] as List).first;
      imageUrl = first?.toString() ?? '';
    } else {
      imageUrl = '';
    }
    final department = (json['department'] ?? json['category']) as String?;

    // Normalize imageUrl to handle common JSON shapes and broken values
    imageUrl = imageUrl.trim();
    if (imageUrl.startsWith('//')) imageUrl = 'https:$imageUrl';
    if (imageUrl.startsWith('http:'))
      imageUrl = imageUrl.replaceFirst('http:', 'https:');
    // if the value contains 'http' but doesn't start with it, extract from that position
    if (imageUrl.contains('http') && !imageUrl.startsWith('http')) {
      imageUrl = imageUrl.substring(imageUrl.indexOf('http'));
    }
    // replace spaces
    imageUrl = imageUrl.replaceAll(' ', '%20');
    // if it's not a network url and not an asset path, clear it (keeps UI fallback simple)
    if (imageUrl.isNotEmpty &&
        !imageUrl.startsWith('http') &&
        !imageUrl.startsWith('assets/')) {
      imageUrl = '';
    }

    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      department: department,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': imageUrl,
      'department': department,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Product && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => jsonEncode(toJson());
}
