import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmiq_app/providers/cart_provider.dart';
import 'home_screen.dart';
import 'support_screen.dart';
import 'cart_screen.dart';
// REMOVED: No longer need to import profile_screen here

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // REMOVED: ProfileScreen is no longer part of the main pages
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SupportScreen(),
    CartScreen(),
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
        selectedItemColor: const Color(0xFF3B5D46),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        // REMOVED: The BottomNavigationBarItem for Profile is gone
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
        ],
      ),
    );
  }
}

