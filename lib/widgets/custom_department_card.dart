import 'package:flutter/material.dart';

class CustomDepartmentCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const CustomDepartmentCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stack) => Image.asset(
                            'assets/images/phone.png',
                            fit: BoxFit.cover),
                      )
                    : (imageUrl.startsWith('assets/')
                        ? Image.asset(imageUrl, fit: BoxFit.cover)
                        : Image.asset('assets/images/phone.png',
                            fit: BoxFit.cover)),
              ),
            ),
            SizedBox(height: 8),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
