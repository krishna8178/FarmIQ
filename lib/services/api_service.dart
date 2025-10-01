// lib/services/api_service.dart
import 'dart:convert';
import 'package:farmiq_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmiq_app/models/user.dart';
import 'package:logging/logging.dart';
import 'package:farmiq_app/models/cart_model.dart';
import 'package:farmiq_app/models/ngo_model.dart'; // Import the new NGO model

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:3000/api';
  final _log = Logger('ApiService');

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<User?> getUserProfile() async {
    final token = await _getToken();
    if (token == null) {
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
    } catch (e, stackTrace) {
      _log.severe("Error fetching user profile", e, stackTrace);
    }
    return null;
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // New function to get NGOs
  Future<List<NGO>> getNgos() async {
    final response = await http.get(Uri.parse('$_baseUrl/ngos'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => NGO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load NGOs');
    }
  }

  Future<Cart> getCart() async {
    // TODO: Implement actual API call
    return Cart(id: '1', items: []);
  }

  Future<void> addToCart(String productId, {required int quantity}) async {
    // TODO: Implement actual API call
  }

  Future<void> deleteFromCart(String cartItemId) async {
    // TODO: Implement actual API call
  }
}