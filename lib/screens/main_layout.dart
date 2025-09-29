import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'guide_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // This variable will keep track of which tab is currently selected.
  // 0 = Home, 1 = Guide, 2 = Profile
  int _selectedIndex = 0;

  // This is the list of the actual pages we will switch between.
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    GuideScreen(),
    ProfileScreen(),
  ];

  // This function is called when the user taps an icon in the footer.
  void _onItemTapped(int index) {
    // setState rebuilds the widget with the new selected index.
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body will show the currently selected page from our list.
      body: _pages[_selectedIndex],

      // This is where we define the footer.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlights the correct icon
        onTap: _onItemTapped, // Calls our function on tap
        selectedItemColor: const Color(0xFF3B5D46), // Your theme's green color
        unselectedItemColor: Colors.grey, // Color for inactive icons
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // A different icon for when it's selected
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}