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
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.details), label: "Details"),
    ]);
  }
}