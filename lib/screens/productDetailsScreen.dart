import 'package:flutter/material.dart';
import 'package:assignment2/models/product.dart';
import 'package:provider/provider.dart';
import 'package:assignment2/provider/card_provider.dart';
import 'package:assignment2/provider/fsvorite_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              product.imageUrl.isNotEmpty && product.imageUrl.startsWith('http')
                  ? Image.network(
                      product.imageUrl,
                      height: 200,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()));
                      },
                      errorBuilder: (c, e, s) => const SizedBox(
                        height: 200,
                        child: Center(
                            child: Icon(Icons.broken_image,
                                size: 64, color: Colors.grey)),
                      ),
                    )
                  : (product.imageUrl.isNotEmpty
                      ? Image.asset(product.imageUrl, height: 200)
                      : const SizedBox(
                          height: 200,
                          child:
                              Center(child: Icon(Icons.image_not_supported)))),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // زر المفضلة
                  Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      final isFav = favoriteProvider.isFavorite(product.id);
                      return ElevatedButton.icon(
                        onPressed: () {
                          favoriteProvider.toggleFavorite(product);
                        },
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.blue,
                        ),
                        label:
                            Text(isFav ? 'إزالة من المفضلة' : 'إضافة للمفضلة'),
                      );
                    },
                  ),
                  // زر السلة
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      final inCart = cartProvider.isInCart(product.id);
                      return ElevatedButton.icon(
                        onPressed: () {
                          if (inCart) {
                            cartProvider.removeFromCart(product.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('تم إزالة المنتج من السلة')),
                            );
                          } else {
                            cartProvider.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('تم إضافة المنتج للسلة')),
                            );
                          }
                        },
                        icon: Icon(
                          inCart
                              ? Icons.shopping_cart
                              : Icons.shopping_cart_outlined,
                        ),
                        label: Text(inCart ? 'إزالة من السلة' : 'إضافة للسلة'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
