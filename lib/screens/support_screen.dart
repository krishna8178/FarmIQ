// lib/screens/support_screen.dart
import 'package:flutter/material.dart';
import 'package:farmiq_app/models/ngo_model.dart';
import 'package:farmiq_app/services/api_service.dart';
import 'package:farmiq_app/utils/constants.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final ApiService _apiService = ApiService();
  List<NGO> _allNgos = [];
  List<NGO> _filteredNgos = [];
  bool _isLoading = true;
  String? _selectedState;
  final List<String> _states = ['Kerala', 'Punjab', 'Jharkhand'];

  @override
  void initState() {
    super.initState();
    _fetchNgos();
  }

  Future<void> _fetchNgos() async {
    try {
      final ngos = await _apiService.getNgos();
      if (mounted) {
        setState(() {
          _allNgos = ngos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Handle error, e.g., show a snackbar
      }
    }
  }

  void _filterNgosByState(String? state) {
    setState(() {
      _selectedState = state;
      if (state == null) {
        _filteredNgos = [];
      } else {
        _filteredNgos =
            _allNgos.where((ngo) => ngo.state.toLowerCase() == state.toLowerCase()).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support & NGOs',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedState,
              hint: const Text('Select a State'),
              isExpanded: true,
              items: _states.map((String state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: _filterNgosByState,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedState == null
                ? const Center(
                child: Text('Please select a state to see NGOs.'))
                : _filteredNgos.isEmpty
                ? Center(
                child: Text(
                    'No NGOs found for $_selectedState.'))
                : ListView.builder(
              itemCount: _filteredNgos.length,
              itemBuilder: (context, index) {
                final ngo = _filteredNgos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(ngo.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        if (ngo.description != null)
                          Text(ngo.description!),
                        if (ngo.city != null)
                          Text('City: ${ngo.city}'),
                        if (ngo.contactEmail != null)
                          Text('Email: ${ngo.contactEmail}'),
                        if (ngo.contactPhone != null)
                          Text('Phone: ${ngo.contactPhone}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}