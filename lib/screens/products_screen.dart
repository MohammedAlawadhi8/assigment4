import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment2/models/product.dart';
import 'package:assignment2/screens/productDetailsScreen.dart';
import 'package:assignment2/widgets/custom_product_card.dart';
import 'package:assignment2/services/api_service.dart';
import 'package:assignment2/provider/fsvorite_provider.dart';

class ProductsScreen extends StatelessWidget {
  final String departmentName;

  const ProductsScreen({super.key, required this.departmentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(departmentName),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder<List<Product>>(
          future: ApiService.fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('فشل تحميل المنتجات'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (c) =>
                                ProductsScreen(departmentName: departmentName),
                          ),
                        );
                      },
                      child: const Text('أعد المحاولة'),
                    ),
                  ],
                ),
              );
            }

            final all = snapshot.data ?? [];
            if (all.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'لا توجد منتجات متاحة حالياً',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (c) =>
                                ProductsScreen(departmentName: departmentName),
                          ),
                        );
                      },
                      child: const Text('أعد المحاولة'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            }
            final List<Product> departmentProducts = all
                .where((product) =>
                    (product.department != null &&
                        product.department!.toLowerCase() ==
                            departmentName.toLowerCase()) ||
                    product.name
                        .toLowerCase()
                        .contains(departmentName.toLowerCase()))
                .toList();

            final displayList =
                departmentProducts.isEmpty ? all : departmentProducts;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final product = displayList[index];
                final isFav = Provider.of<FavoriteProvider>(context)
                    .isFavorite(product.id);
                return CustomProductCard(
                  title: product.name,
                  description: product.description,
                  imageUrl: product.imageUrl,
                  price: product.price,
                  isFavorite: isFav,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
