import 'package:flutter/material.dart';
import 'package:assignment2/productDetailsScreen.dart';
import 'package:assignment2/models/product.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final List<Product> products = [
    Product(
      id: "1",
      name: "عصارة",
      description: "عصارة مليح",
      price: 800,
      imageUrl: "assets/images/squeezer.png"
    ),
    Product(
      id: "2",
      name: "هاتف",
      description: "هاتف ضد الماء",
      price: 300,
      imageUrl: "assets/images/phone.png"
    ),
    Product(
      id: "3",
      name: "سماعة",
      description: "سماعة قوي",
      price: 400,
      imageUrl: "assets/images/airphone.png"
    ),
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
   
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
    
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
  
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
    
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
    
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
    
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
    
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
    
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
    
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
    
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
    
    Product(
      id: "4",
      name: "شاحن",
      description: "شاحن سريع",
      price: 400,
      imageUrl: "assets/images/charger.png"
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: CircleAvatar(child: Image.asset(product.imageUrl)),
                title: Text(product.name),
                subtitle: Text("${product.price}\$"),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(product: product),
                    ),
                  );
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result)),
                    );
                  }
                },
              ));
        },
      ),
    );
  }
}
