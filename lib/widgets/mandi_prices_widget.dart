// widgets/mandi_prices_widget.dart

import 'package:flutter/material.dart';
import '../services/mandi_service.dart'; // Make sure this path is correct

class MandiPricesWidget extends StatefulWidget {
  const MandiPricesWidget({super.key});

  @override
  State<MandiPricesWidget> createState() => _MandiPricesWidgetState();
}

class _MandiPricesWidgetState extends State<MandiPricesWidget> {
  late Future<List<MandiRecord>> futureMandiPrices;

  @override
  void initState() {
    super.initState();
    futureMandiPrices = fetchMandiPrices();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.bar_chart_rounded), // Icon for the drawer item
      title: const Text('Mandi Prices'),
      children: <Widget>[
        // This is the content that will be shown when expanded
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List<MandiRecord>>(
            future: futureMandiPrices,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text('Error: Could not load prices.')),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text('No prices found.')),
                );
              } else {
                // Build a column of the price data
                return Column(
                  children: snapshot.data!.map((record) {
                    return ListTile(
                      title: Text(record.commodity),
                      subtitle: Text('${record.market}, ${record.state}'),
                      trailing: Text(
                        '₹${record.price}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}