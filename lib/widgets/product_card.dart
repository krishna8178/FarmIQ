import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmiq_app/models/product.dart';
import 'package:farmiq_app/providers/cart_provider.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final proxiedImageUrl = 'http://10.0.2.2:3000/api/image-proxy?url=${Uri.encodeComponent(product.imageUrl)}';

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              proxiedImageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.agriculture, size: 50, color: Colors.grey);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${currencyFormatter.format(product.priceCents / 100)}/kg',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          ElevatedButton(
            // --- THIS IS THE CORRECTED CODE ---
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).addToCart(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3b5d46),
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('Add to Cart'),
          )
        ],
      ),
    );
  }
}