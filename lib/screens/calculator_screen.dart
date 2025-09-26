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
          title: const Text('Farm Calculators'),
          backgroundColor: const Color(0xFF3b5d46),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Yield Calculator'),
              Tab(text: 'Fertilizer Calculator'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Each child corresponds to a tab
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

  // Mock data for crop factors (yield per plant in kg)
  final Map<String, double> _cropFactors = {
    'Wheat': 0.002, 'Rice': 0.0025, 'Corn': 0.003, 'Sugarcane': 0.005,
  };

  void _calculateYield() {
    if (_formKey.currentState!.validate() && _selectedCrop != null) {
      final double area = double.tryParse(_areaController.text) ?? 0;
      final double density = double.tryParse(_densityController.text) ?? 0;
      final double cropFactor = _cropFactors[_selectedCrop!] ?? 0;

      // Simple calculation: yield = area (in m^2) * density (plants/m^2) * yield/plant
      // Assuming area is in acres, convert to m^2 (1 acre = 4046.86 m^2)
      final double estimatedYield = (area * 4046.86 * density * cropFactor) / 1000; // in Tonnes

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
              child: const Text('Calculate Yield', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 30),
            if (_yieldResult.isNotEmpty)
              Text(_yieldResult, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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

      // Simple mock calculation based on standard recommendations for 1 acre
      final double nitrogen = area * 50; // 50 kg N per acre
      final double phosphorus = area * 25; // 25 kg P per acre
      final double potassium = area * 25; // 25 kg K per acre

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
              child: const Text('Calculate Fertilizer', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 30),
            if (_fertilizerResult.isNotEmpty)
              Text(_fertilizerResult, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}