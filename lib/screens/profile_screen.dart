// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:farmiq_app/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmiq_app/services/api_service.dart'; // Import ApiService
import 'package:farmiq_app/models/user.dart'; // Import User model
import 'package:farmiq_app/widgets/list_tile_skeleton.dart'; // Import the new skeleton

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<User?>? _userFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the user profile when the screen loads
    _userFuture = ApiService().getUserProfile();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF3b5d46),
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // --- SHOW THE SKELETON UI WHILE LOADING ---
            return const ListTileSkeleton();
          } else if (snapshot.hasError || !snapshot.hasData) {
            // Show an error or a fallback if data fails to load
            return const Center(child: Text('Could not load profile.'));
          }

          // --- SHOW THE REAL UI WHEN DATA IS LOADED ---
          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfileInfoTile(Icons.person, 'Name', user.name),
                _buildProfileInfoTile(Icons.email, 'Email', user.email),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfoTile(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3b5d46)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}