import 'package:flutter/material.dart';
import 'package:farmiq_app/models/cart_model.dart';
import 'package:farmiq_app/services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Cart? _cart;
  bool _isLoading = false;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;

  CartProvider() {
    fetchCart();
  }

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      _cart = await _apiService.getCart();
    } catch (e) {
      print(e); // In a real app, handle this error more gracefully
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(String productId, {int quantity = 1}) async {
    try {
      // --- THIS IS THE CORRECTED LINE ---
      // We now explicitly name the 'quantity' parameter
      await _apiService.addToCart(productId, quantity: quantity);

      // After adding, refresh the cart to show the new item
      await fetchCart();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _apiService.deleteFromCart(cartItemId);
      // After removing, refresh the cart
      await fetchCart();
    } catch (e) {
      print(e);
    }
  }
}

