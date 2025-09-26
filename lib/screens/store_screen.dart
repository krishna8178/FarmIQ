// lib/screens/store_screen.dart
import 'package:flutter/material.dart';
import 'package:farmiq_app/models/product.dart';
import 'package:farmiq_app/services/api_service.dart';
import 'package:farmiq_app/widgets/product_card.dart'; // We will create this next

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key}) ;

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    // Fetch the products when the screen is first loaded
    _products = ApiService().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Store'),
        backgroundColor: const Color(0xFF3b5d46),
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while fetching data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if something went wrong
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            // If data is available, display it in a grid
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards per row
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.8, // Adjust aspect ratio for better look
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // Use the ProductCard widget for each item
                return ProductCard(product: snapshot.data![index]);
              },
            );
          }
          // Default message if there's no data
          return const Center(child: Text("No products found."));
        },
      ),
    );
  }
}