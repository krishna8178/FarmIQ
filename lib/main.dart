import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Import the provider package
import 'package:farmiq_app/providers/cart_provider.dart'; // 2. Import your CartProvider
import 'package:farmiq_app/screens/auth_check_screen.dart';

void main() {
  // 3. Wrap your entire application in the ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(), // This creates the "cart brain"
      child: const FarmIQApp(), // Your app now lives inside the provider
    ),
  );
}

class FarmIQApp extends StatelessWidget {
  const FarmIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmIQ',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF3b5d46),
        scaffoldBackgroundColor: const Color(0xFFf2f1e6),
        fontFamily: 'Poppins',
      ),
      home: const AuthCheckScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

