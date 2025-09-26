// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final String description;
  final int priceCents;
  final String imageUrl;

  Product({required this.id, required this.name, required this.description, required this.priceCents, required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      priceCents: json['priceCents'],
      imageUrl: json['imageUrl'],
    );
  }
}