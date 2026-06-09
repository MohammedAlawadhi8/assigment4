import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment2/provider/card_provider.dart';
import 'package:assignment2/screens/productDetailsScreen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
        centerTitle: true,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.items.isEmpty)  return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('تأكيد'),
                      content: const Text('هل تريد إفراغ السلة؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            cartProvider.clearCart();
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
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            if (cartProvider.items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'السلة فارغة',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final product = cartProvider.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(product.imageUrl),
                    ),
                    title: Text(product.name),
                    subtitle: Text('${product.price.toStringAsFixed(2)}\$'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        cartProvider.removeFromCart(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم إزالة المنتج من السلة')),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
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
