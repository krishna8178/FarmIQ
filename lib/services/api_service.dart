// lib/services/api_service.dart
import 'dart:convert';
import 'package:farmiq_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmiq_app/models/user.dart';
import 'package:logging/logging.dart';
import 'package:farmiq_app/models/cart_model.dart';
import 'package:farmiq_app/models/ngo_model.dart';

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:3000/api';
  final _log = Logger('ApiService');

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<User?> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/me'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
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

  Future<List<NGO>> getNgos() async {
    final response = await http.get(Uri.parse('$_baseUrl/ngos'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => NGO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load NGOs');
    }
  }

  // --- THIS IS THE CORRECTED CODE ---
  Future<Cart> getCart() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cart'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      _log.warning('Failed to load cart: ${response.statusCode}');
      throw Exception('Failed to load cart');
    }
  }

  Future<void> addToCart(String productId, {int quantity = 1}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cart/items'),
      headers: await _getHeaders(),
      body: json.encode({'productId': productId, 'qty': quantity}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _log.warning('Failed to add item to cart: ${response.statusCode}');
      throw Exception('Failed to add item to cart');
    }
  }

  Future<void> deleteFromCart(String cartItemId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/cart/items/$cartItemId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _log.warning('Failed to delete item from cart: ${response.statusCode}');
      throw Exception('Failed to delete item from cart');
    }
  }
}