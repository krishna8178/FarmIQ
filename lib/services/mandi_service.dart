// services/mandi_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. Data Model to hold the price information
class MandiRecord {
  final String commodity;
  final String market;
  final String state;
  final String price;

  MandiRecord({
    required this.commodity,
    required this.market,
    required this.state,
    required this.price,
  });

  // Factory constructor to parse JSON
  factory MandiRecord.fromJson(Map<String, dynamic> json) {
    return MandiRecord(
      commodity: json['commodity'] ?? 'N/A',
      market: json['market'] ?? 'N/A',
      state: json['state'] ?? 'N/A',
      price: (json['modal_price'] ?? '0').toString(),
    );
  }
}

// 2. Function to fetch and parse the data
Future<List<MandiRecord>> fetchMandiPrices() async {
  const String apiKey = "579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b";
  const String url = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=$apiKey&format=json&offset=0&limit=10";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List records = jsonData['records'];
    return records.map((item) => MandiRecord.fromJson(item)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load mandi prices');
  }
}