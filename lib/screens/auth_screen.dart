import 'package:flutter/material.dart';
import 'package:farmiq_app/services/auth_service.dart';
import 'package:farmiq_app/screens/home_screen.dart';
import 'package:farmiq_app/widgets/custom_button.dart';
import 'package:farmiq_app/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This is the public StatefulWidget
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // This method creates the private state class
  State<AuthScreen> createState() => _AuthScreenState();
}

// This is the private State class, with the leading underscore
class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  String _errorMessage = '';

  bool _rememberMe = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        if (_isLogin) {
          final token = await _authService.login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          if (token != null) {
            if (_rememberMe) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token);
            }
            if (!mounted) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            setState(() {
              _errorMessage = 'Login failed. Please check your credentials.';
            });
          }
        } else {
          bool success = await _authService.signUp(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
          if (success) {
            setState(() {
              _isLogin = true;
              _errorMessage = 'Signup successful! Please log in.';
            });
          } else {
            setState(() {
              _errorMessage = 'Signup failed. The email might already be in use.';
            });
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Could not connect to the server. Please try again.';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
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
                Text(
                  _isLogin ? 'Welcome Back!' : 'Create Account',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3b5d46),
                  ),
                ),
                const SizedBox(height: 40),
                if (!_isLogin) ...[
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                ],
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  isPassword: true,
                  icon: Icons.lock,
                ),
                if (_isLogin)
                  CheckboxListTile(
                    title: const Text("Stay Logged In"),
                    value: _rememberMe,
                    onChanged: (newValue) {
                      setState(() {
                        _rememberMe = newValue ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                const SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                CustomButton(
                  text: _isLogin ? 'Login' : 'Sign Up',
                  onPressed: _submitForm,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),
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