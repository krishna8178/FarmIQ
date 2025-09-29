import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmiq_app/providers/cart_provider.dart'; // This line is crucial
import 'package:farmiq_app/screens/auth_check_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const FarmIQApp(),
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