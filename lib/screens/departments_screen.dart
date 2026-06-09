import 'package:flutter/material.dart';
import 'package:assignment2/services/api_service.dart';
import 'package:assignment2/screens/products_screen.dart';
import 'package:assignment2/widgets/custom_department_card.dart';
import 'package:assignment2/data/department_data.dart' as local_data;

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  late Future<List<Map<String, String>>> _categoriesFuture;

  final Map<String, String> _translations = {
    'electronics': 'إلكترونيات',
    'jewelery': 'مجوهرات',
    "men's clothing": 'ملابس رجالية',
    "women's clothing": 'ملابس نسائية',
  };

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService.fetchCategoryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأقسام'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Map<String, String>>>(
            future: _categoriesFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                // fallback to local static data
                return _buildGridFromLocal();
              }
              final cats = snap.data ?? [];
              if (cats.isEmpty) return _buildGridFromLocal();

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: cats.length,
                itemBuilder: (context, index) {
                  final info = cats[index];
                  final key = info['key'] ?? '';
                  final image = (info['image'] ?? '').isNotEmpty
                      ? info['image']!
                      : 'assets/images/phone.png';
                  final title =
                      _translations[key.toLowerCase()] ?? key.toString();
                  return CustomDepartmentCard(
                    title: title,
                    imageUrl: image,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsScreen(
                            departmentName: key,
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
      ),
    );
  }

  Widget _buildGridFromLocal() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: local_data.departments.length,
      itemBuilder: (context, index) {
        final department = local_data.departments[index];
        return CustomDepartmentCard(
          title: department.name,
          imageUrl: department.imageUrl,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsScreen(
                  departmentName: department.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
