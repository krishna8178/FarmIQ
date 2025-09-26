// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:farmiq_app/services/auth_service.dart';
import 'package:farmiq_app/screens/home_screen.dart';
import 'package:farmiq_app/widgets/custom_button.dart';
import 'package:farmiq_app/widgets/custom_textfield.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true; // To toggle between Login and Signup
  bool _isLoading = false;
  String _errorMessage = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      bool success;
      if (_isLogin) {
        success = await _authService.login(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        success = await _authService.signUp(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );
      }

      // This check is the fix for the warning
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Now it's safe to navigate
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = _isLogin
              ? 'Login failed. Please check your credentials.'
              : 'Signup failed. The email might already be in use.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo/Title
                Text(
                  _isLogin ? 'Welcome Back!' : 'Create Account',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3b5d46),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin ? 'Login to your FarmIQ account' : 'Start your journey with us',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // Name Field (only for Signup)
                if (!_isLogin)
                  ...[
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                  ],

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  isPassword: true,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 30),

                // Error Message Display
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Submit Button
                CustomButton(
                  text: _isLogin ? 'Login' : 'Sign Up',
                  onPressed: _submitForm,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),

                // Toggle between Login and Signup
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = '';
                      _formKey.currentState?.reset();
                    });
                  },
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Sign Up"
                        : 'Already have an account? Login',
                    style: const TextStyle(color: Color(0xFF3b5d46)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}