import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// A simple model to hold NGO data
class Ngo {
  final String name;
  final String city;
  final String? phone;
  final String? email;

  Ngo({required this.name, required this.city, this.phone, this.email});
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  // Helper function to launch URLs (tel:, mailto:)
  Future<void> _launchUrl(String urlString, BuildContext context) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your list of NGOs for Kerala
    final List<Ngo> keralaNgos = [
      Ngo(name: 'Bharath Sevak Samaj (Kerala Pradesh)', city: 'Thiruvananthapuram', phone: '0471-433845'),
      Ngo(name: 'Bodhi Vanitha Samajam', city: 'Thiruvananthapuram', phone: null), // Phone not available
      Ngo(name: 'Bodhini Kalasamskarika Vedi', city: 'Alappuzha', phone: '9447727114'),
      Ngo(name: 'Christian College', city: 'Alappuzha', email: 'christiancollege@gmail.com', phone: '9446974398'),
      Ngo(name: 'FREED (Forum for Rural Environment and Economic Development)', city: 'Alappuzha', email: null, phone: '9995214442'),
      Ngo(name: 'Gandhi Smaraka Grama Seva Kendram', city: 'Alappuzha', email: null, phone: '9447086549'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support & NGOs'),
        backgroundColor: const Color(0xFF3b5d46),
        automaticallyImplyLeading: false, // Removes back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting the state (currently static)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButton<String>(
                value: 'Kerala',
                isExpanded: true,
                underline: const SizedBox(), // Hides the default underline
                onChanged: (String? newValue) {
                  // TODO: Implement logic to switch between states
                },
                items: <String>['Kerala']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // List of NGOs
            Expanded(
              child: ListView.builder(
                itemCount: keralaNgos.length,
                itemBuilder: (context, index) {
                  final ngo = keralaNgos[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ngo.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('City: ${ngo.city}'),
                          const SizedBox(height: 8),

                          // --- INTERACTIVE CONTACT ROW ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (ngo.phone != null)
                                TextButton.icon(
                                  icon: const Icon(Icons.phone, size: 18),
                                  label: Text(ngo.phone!),
                                  onPressed: () => _launchUrl('tel:${ngo.phone}', context),
                                ),
                              if (ngo.email != null)
                                TextButton.icon(
                                  icon: const Icon(Icons.email, size: 18),
                                  label: const Text('Email'),
                                  onPressed: () => _launchUrl('mailto:${ngo.email}', context),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
