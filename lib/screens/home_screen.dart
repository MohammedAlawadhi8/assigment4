import 'package:flutter/material.dart';
import 'package:assignment2/screens/departments_screen.dart';
import 'package:assignment2/screens/favorites_screen.dart';
import 'package:assignment2/screens/cart_screen.dart';

// removed unused imports: login, register
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DepartmentsScreen(),
    const FavoritesScreen(),
    const CartScreen(),
  ];

  final List<String> _titles = [
    'الأقسام',
    'المفضلات',
    'سلة المشتريات',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: _titles[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: _titles[1],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: _titles[2],
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
