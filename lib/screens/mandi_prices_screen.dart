// lib/screens/mandi_prices_screen.dart

import 'package:flutter/material.dart';
import '../services/mandi_service.dart';

class MandiPricesScreen extends StatefulWidget {
  const MandiPricesScreen({super.key});

  @override
  State<MandiPricesScreen> createState() => _MandiPricesScreenState();
}

class _MandiPricesScreenState extends State<MandiPricesScreen> {
  late Future<List<MandiRecord>> futureMandiPrices;

  @override
  void initState() {
    super.initState();
    futureMandiPrices = fetchMandiPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandi Prices'),
        backgroundColor: Colors.green[700],
      ),
      // --- START OF CHANGES ---
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. This is the new top line you wanted
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "The latest mandi rates (per quintal)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),

          // 2. The FutureBuilder is wrapped in an Expanded widget
          // This tells it to fill all the remaining space below the text
          Expanded(
            child: FutureBuilder<List<MandiRecord>>(
              future: futureMandiPrices,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final record = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          title: Text(
                            record.commodity,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('${record.market}, ${record.state}'),
                          trailing: Text(
                            '₹${record.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data found.'));
                }
              },
            ),
          ),
        ],
      ),
      // --- END OF CHANGES ---
    );
  }
}