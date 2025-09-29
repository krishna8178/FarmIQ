import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['imageUrl'];
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'No Name Available',
      // This now checks if the URL is valid before using it.
      imageUrl: (imageUrl != null && imageUrl.isNotEmpty)
          ? imageUrl
          : 'https://via.placeholder.com/150',
      price: (json['price'] as num? ?? 0.0).toDouble(),
    );
  }
}