// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmiq_app/providers/cart_provider.dart';
import 'package:farmiq_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:farmiq_app/models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cart;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: cartProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cart == null || cart.items.isEmpty
          ? const Center(
        child: Text('Your cart is empty.', style: TextStyle(fontSize: 18)),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: Image.network(
                        // Using the image proxy for product images
                        'http://10.0.2.2:3000/api/products/image-proxy?url=${Uri.encodeComponent(item.product.imageUrl)}',
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                      ),
                      title: Text(item.product.name),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Call provider to remove item
                          Provider.of<CartProvider>(context, listen: false).removeFromCart(item.id);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildCheckoutSection(context, cart, currencyFormatter),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, Cart cart, NumberFormat currencyFormatter) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                currencyFormatter.format(cart.totalPrice / 100),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: cart.items.isEmpty ? null : () {
              // TODO: Implement checkout logic
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16)
            ),
            child: const Text(
              'PROCEED TO CHECKOUT',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}