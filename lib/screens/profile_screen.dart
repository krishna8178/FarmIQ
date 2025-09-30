import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmiq_app/models/user.dart';      // Corrected Import
import 'package:farmiq_app/services/api_service.dart';   // Import your API service
import 'package:farmiq_app/screens/login_screen.dart';    // Import the Login screen for logout navigation

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // A variable to hold the result of our API call.
  // 'Future' means this data will arrive in the future.
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    // As soon as the screen is created, we start fetching the user's profile.
    _userFuture = ApiService().getUserProfile();
  }

  // --- This function handles the logout process ---
  Future<void> _logout() async {
    // 1. Remove the saved token from the device's storage.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // This check is important to prevent errors if the user navigates away quickly.
    if (!mounted) return;

    // 2. Navigate the user back to the LoginScreen.
    // pushAndRemoveUntil clears the navigation history, so the user can't press "back" to get into the app.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile',
        ),
        backgroundColor: const Color(0xFF3b5d46), // Your theme color
        actions: [
          // Add a logout button to the top bar for easy access.
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      // FutureBuilder is a special widget that builds the UI based on the state of a Future.
      body: FutureBuilder<User?>(
        future: _userFuture, // We tell it to watch our _userFuture variable.
        builder: (context, snapshot) {
          // Case 1: The data is still loading.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Case 2: An error occurred, or no user data was returned.
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Could not load profile. Please try again.'),
            );
          }

          // Case 3: The data has arrived successfully!
          final user = snapshot.data!; // Get the loaded user data.

          // Now, we build the profile UI using the user's data.
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFF3b5d46),
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name, // Display the user's name from the data
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3b5d46),
                  ),
                ),
                const Divider(thickness: 1.5),
                const SizedBox(height: 16),

                InfoTile(icon: Icons.email, title: 'Email', value: user.email),
                const SizedBox(height: 16),
                InfoTile(icon: Icons.phone, title: 'Mobile', value: user.mobile ?? 'Not provided'),
              ],
            ),
          );
        },
      ),
    );
  }
}

// A reusable helper widget for displaying a piece of user information.
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}