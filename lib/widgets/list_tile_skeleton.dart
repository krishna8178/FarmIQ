import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        // This generates 3 skeleton rows for the list
        children: List.generate(3, (index) => _buildSkeletonRow()),
      ),
    );
  }

  // This method should be outside the build method, but inside the class
  Widget _buildSkeletonRow() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 16, color: Colors.black),
                const SizedBox(height: 8),
                Container(width: double.infinity, height: 14, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}