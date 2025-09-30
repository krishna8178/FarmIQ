// lib/screens/calculator_screen.dart
import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // The number of tabs
      child: Scaffold(
        appBar: AppBar(
          // EDITED: Made AppBar title white and bold
          title: const Text(
            'Farm Calculators',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF3b5d46),
          iconTheme: const IconThemeData(color: Colors.white), // Ensures back arrow is white
          // EDITED: Made Tab text white and bold
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Yield Calculator'),
              Tab(text: 'Fertilizer Calculator'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _YieldCalculatorView(),
            _FertilizerCalculatorView(),
          ],
        ),
      ),
    );
  }
}

// A private widget for the Yield Calculator
class _YieldCalculatorView extends StatefulWidget {
  const _YieldCalculatorView();

  @override
  _YieldCalculatorViewState createState() => _YieldCalculatorViewState();
}

class _YieldCalculatorViewState extends State<_YieldCalculatorView> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  final _densityController = TextEditingController();
  String? _selectedCrop;
  String _yieldResult = '';

  final Map<String, double> _cropFactors = {
    'Wheat': 0.002, 'Rice': 0.0025, 'Corn': 0.003, 'Sugarcane': 0.005,
  };

  void _calculateYield() {
    if (_formKey.currentState!.validate() && _selectedCrop != null) {
      final double area = double.tryParse(_areaController.text) ?? 0;
      final double density = double.tryParse(_densityController.text) ?? 0;
      final double cropFactor = _cropFactors[_selectedCrop!] ?? 0;

      final double estimatedYield = (area * 4046.86 * density * cropFactor) / 1000;

      setState(() {
        _yieldResult = 'Estimated Yield: ${estimatedYield.toStringAsFixed(2)} Tonnes';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedCrop,
              hint: const Text('Select Crop Type'),
              onChanged: (value) => setState(() => _selectedCrop = value),
              items: _cropFactors.keys.map((crop) => DropdownMenuItem(value: crop, child: Text(crop))).toList(),
              validator: (value) => value == null ? 'Please select a crop' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Area (in acres)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter area' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _densityController,
              decoration: const InputDecoration(labelText: 'Planting Density (plants per m²)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter density' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _calculateYield,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3b5d46), padding: const EdgeInsets.symmetric(vertical: 16)),
              // EDITED: Made button text white and bold
              child: const Text('Calculate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 30),
            if (_yieldResult.isNotEmpty)
              Text(
                _yieldResult,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3b5d46),
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

// A private widget for the Fertilizer Calculator
class _FertilizerCalculatorView extends StatefulWidget {
  const _FertilizerCalculatorView();

  @override
  _FertilizerCalculatorViewState createState() => _FertilizerCalculatorViewState();
}

class _FertilizerCalculatorViewState extends State<_FertilizerCalculatorView> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  String _fertilizerResult = '';

  void _calculateFertilizer() {
    if (_formKey.currentState!.validate()) {
      final double area = double.tryParse(_areaController.text) ?? 0;

      final double nitrogen = area * 50;
      final double phosphorus = area * 25;
      final double potassium = area * 25;

      setState(() {
        _fertilizerResult = 'Recommended:\n'
            'Nitrogen (N): ${nitrogen.toStringAsFixed(2)} kg\n'
            'Phosphorus (P): ${phosphorus.toStringAsFixed(2)} kg\n'
            'Potassium (K): ${potassium.toStringAsFixed(2)} kg';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter your farm area to get a general fertilizer recommendation.'),
            const SizedBox(height: 20),
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Area (in acres)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter area' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _calculateFertilizer,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3b5d46), padding: const EdgeInsets.symmetric(vertical: 16)),
              // EDITED: Made button text white and bold
              child: const Text('Calculate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 30),
            if (_fertilizerResult.isNotEmpty)
              Text(
                _fertilizerResult,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3b5d46),
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}