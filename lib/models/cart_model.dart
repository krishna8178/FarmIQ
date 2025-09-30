import 'package:farmiq_app/models/product.dart';

// Represents a single item within the cart
class CartItem {
  final String id;
  final int quantity;
  final Product product;

  CartItem({required this.id, required this.quantity, required this.product});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
    );
  }
}

// Represents the entire shopping cart
class Cart {
  final String? id;
  final List<CartItem> items;

  Cart({this.id, required this.items});

  // Calculates the total price of all items in the cart
  double get totalPrice {
    // Corrected to use priceCents
    return items.fold(0.0, (sum, item) => sum + (item.product.priceCents * item.quantity));
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List;
    List<CartItem> itemList = itemsFromJson.map((i) => CartItem.fromJson(i)).toList();

    return Cart(
      id: json['id'],
      items: itemList,
    );
  }
}