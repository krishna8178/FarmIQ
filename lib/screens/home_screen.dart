// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:farmiq_app/models/user.dart'; // Make sure User model is imported
import 'package:farmiq_app/models/weather.dart';
import 'package:farmiq_app/services/weather_service.dart';
import 'package:farmiq_app/screens/store_screen.dart';
import 'package:farmiq_app/screens/community_chat_screen.dart';
import 'package:farmiq_app/screens/disease_guide_screen.dart';
import 'package:farmiq_app/screens/calculator_screen.dart';
import 'package:farmiq_app/screens/chatbot_screen.dart';
import 'package:farmiq_app/screens/profile_screen.dart';
import 'package:farmiq_app/services/api_service.dart';
import 'package:farmiq_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmiq_app/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Weather>? _weatherFuture;
  // EDITED: Changed from String to hold the full User object
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherService().getWeather();
    _loadUserData();
  }

  // EDITED: Now saves the entire user object
  Future<void> _loadUserData() async {
    final user = await ApiService().getUserProfile();
    if (user != null && mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // EDITED: Updated to use the _currentUser object
        title: Text(
          _currentUser != null ? 'Welcome, ${_currentUser!.name}!' : 'FARMIQ',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
        ],
      ),
      // EDITED: Updated the Drawer with UserAccountsDrawerHeader
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (_currentUser != null)
              UserAccountsDrawerHeader(
                accountName: Text(
                  _currentUser!.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(_currentUser!.email),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                ),
              ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Store'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(),
            _buildOptionsGrid(),
            _buildSectionTitle('Featured Products'),
            _buildFeaturedProducts(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatbotScreen()));
        },
        backgroundColor: const Color(0xFF3b5d46),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  // --- No changes below this line ---

  Widget _buildBanner() {
    return Container(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/mainbackground.jpeg',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: _buildWeatherCard(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FarmIQ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 7.0, color: Colors.black87)],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBackgroundColor,
                    foregroundColor: kPrimaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Learn More', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return FutureBuilder<Weather>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.white);
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Icon(Icons.cloud_off, color: Colors.white);
        }
        final weather = snapshot.data!;
        return Card(
          color: Colors.black.withAlpha((0.4 * 255).round()),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(weather.locationName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Image.network('https://openweathermap.org/img/wn/${weather.icon}@2x.png', height: 50),
                Text('${weather.temp.round()}°C', style: const TextStyle(color: Colors.white, fontSize: 20)),
                Text('Feels like ${weather.feelsLike.round()}°C', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionsGrid() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _buildOptionCard('Community', Icons.people, () => Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityChatScreen()))),
          _buildOptionCard('Products', Icons.store, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreScreen()))),
          _buildOptionCard('Diseases', Icons.bug_report, () => Navigator.push(context, MaterialPageRoute(builder: (context) => DiseaseGuideScreen()))),
          _buildOptionCard('Calculator', Icons.calculate, () => Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorScreen()))),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF3b5d46)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3b5d46)),
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFeaturedProductCard('Fertilizers', 'assets/images/fertilizer.png'),
          _buildFeaturedProductCard('Seeds', 'assets/images/seed.png'),
          _buildFeaturedProductCard('Pesticides', 'assets/images/pesticide.png'),
        ],
      ),
    );
  }

  Widget _buildFeaturedProductCard(String name, String imagePath) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 60),
            const SizedBox(height: 8),
            Text(name, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}