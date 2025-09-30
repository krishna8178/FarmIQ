// lib/screens/disease_guide_screen.dart
import 'package:flutter/material.dart';

class DiseaseGuideScreen extends StatelessWidget {
  const DiseaseGuideScreen({super.key});

  // In a real app, this data would come from an API or a local database
  final List<Map<String, String>> diseaseData = const [
    {'name': 'Powdery Mildew', 'symptoms': 'White, powdery spots on leaves and stems.'},
    {'name': 'Late Blight', 'symptoms': 'Dark green or black spots with white mold on leaves.'},
    {'name': 'Fusarium Wilt', 'symptoms': 'Yellowing of lower leaves that progresses upward.'},
    {'name': 'Anthracnose', 'symptoms': 'Sunken, dark spots on leaves, stems, and fruit.'},
    // Add more diseases here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Disease Guide',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: const Color(0xFF3b5d46),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: diseaseData.length,
        itemBuilder: (context, index) {
          final disease = diseaseData[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(disease['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(disease['symptoms']!),
              leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            ),
          );
        },
      ),
    );
  }
}