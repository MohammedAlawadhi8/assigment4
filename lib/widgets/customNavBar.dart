import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  
 final int index;
 const CustomNavbar({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: Colors.blue,
      items: [
      BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "المفضلات"),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "المشتريات"),
    ]);
  }
}