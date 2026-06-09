import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment2/provider/fsvorite_provider.dart';
import 'package:assignment2/screens/productDetailsScreen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلات'),
        centerTitle: true,
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              if (favoriteProvider.favorites.isEmpty)
                return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('تأكيد'),
                      content: const Text('هل تريد إفراغ قائمة المفضلات؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            favoriteProvider.clearFavorites();
                            Navigator.pop(context);
                          },
                          child: const Text('تأكيد'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            if (favoriteProvider.favorites.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد منتجات في المفضلات',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteProvider.favorites.length,
              itemBuilder: (context, index) {
                final product = favoriteProvider.favorites[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: product.imageUrl.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: product.imageUrl.startsWith('http')
                                ? NetworkImage(product.imageUrl)
                                    as ImageProvider
                                : AssetImage(product.imageUrl),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.image_not_supported)),
                    title: Text(product.name),
                    subtitle: Text('${product.price.toStringAsFixed(2)}\$'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        favoriteProvider.removeFavorite(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('تم إزالة المنتج من المفضلات')),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
