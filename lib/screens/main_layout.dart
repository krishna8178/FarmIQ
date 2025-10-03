import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmiq_app/providers/cart_provider.dart';
import 'home_screen.dart';
import 'support_screen.dart'; // Using your new support screen
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // This is the correct list of pages for your 4-tab layout
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SupportScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF3B5D46), // Your theme color
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible with 4 items
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.support_agent_outlined),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, child) {
                // This will show a badge with the number of items in the cart
                final itemCount = cart.cart?.items.length ?? 0;
                return Badge(
                  label: Text('$itemCount'),
                  isLabelVisible: itemCount > 0,
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

