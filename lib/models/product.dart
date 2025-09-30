import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final int priceCents; // Changed to int

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.priceCents, // Changed to priceCents
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['imageUrl'];
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name Available',
      imageUrl: (imageUrl != null && imageUrl.isNotEmpty)
          ? imageUrl
          : 'https://via.placeholder.com/150',
      priceCents: json['priceCents'] ?? 0, // Changed to priceCents
    );
  }
}