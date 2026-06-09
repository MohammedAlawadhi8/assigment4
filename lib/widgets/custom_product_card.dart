import 'package:flutter/material.dart';

class CustomProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double? price;
  final VoidCallback onTap;
  final bool isFavorite;

  const CustomProductCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.onTap,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: imageUrl.isNotEmpty && imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => const Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: Colors.grey),
                              loadingBuilder: (c, w, chunk) {
                                if (chunk == null) return w;
                                return const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2));
                              },
                            )
                          : (imageUrl.isNotEmpty
                              ? Image.asset(imageUrl, fit: BoxFit.contain)
                              : const Icon(Icons.image_not_supported,
                                  size: 48, color: Colors.grey)),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(description,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              if (price != null)
                Text(
                  '\$${price!.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
