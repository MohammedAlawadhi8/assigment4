import 'package:flutter/material.dart';

import 'package:assignment2/models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final Product product;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(product.name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(product.name, style: const TextStyle(fontSize: 24)),
              Text(product.description),
              Text("${product.price} \$"),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("رجوع مع تأكيد"),
                onPressed: () {
                  Navigator.pop(context, "تم الرجوع من ${product.name}");
                },
              ),
            ],
          ),
        ));
  }
}
