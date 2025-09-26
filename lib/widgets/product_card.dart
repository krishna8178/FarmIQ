// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:farmiq_app/models/product.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  // Use a super parameter for the constructor
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Using the intl package for proper currency formatting
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final price = product.priceCents / 100;

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias, // Ensures the image respects the card's rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              // Show a loading spinner while the image is loading
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              // Show a placeholder icon if the image fails to load
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
              },
            ),
          ),
          // Product Details and Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormatter.format(price),
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // This is where you would add your "Add to Cart" logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3b5d46), // Use backgroundColor for newer Flutter versions
                  ),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}