// lib/services/auth_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart'; // Import the logging package

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:3000/api/auth';
  // Create a logger instance for this file
  final _log = Logger('AuthService');

  Future<bool> signUp(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      // Use the logger instead of print
      _log.warning("Network error during signup.");
      return false;
    } catch (e, stackTrace) {
      // Log the error and the stack trace for better debugging
      _log.severe("An unexpected error occurred during signup", e, stackTrace);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          return true;
        }
      }
      return false;
    } on SocketException {
      _log.warning("Network error during login.");
      return false;
    } catch (e, stackTrace) {
      _log.severe("An unexpected error occurred during login", e, stackTrace);
      return false;
    }
  }
}