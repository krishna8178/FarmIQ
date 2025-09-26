// lib/widgets/product_card_skeleton.dart
import 'package:flutter/material.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 120, // Adjust height to match your ProductCard
            decoration: BoxDecoration(
              color: Colors.black, // Shimmer will animate over this
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Text line placeholders
                Container(width: double.infinity, height: 16, color: Colors.black),
                const SizedBox(height: 8),
                Container(width: 100, height: 14, color: Colors.black),
                const SizedBox(height: 8),
                // Button placeholder
                Container(width: double.infinity, height: 36, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}