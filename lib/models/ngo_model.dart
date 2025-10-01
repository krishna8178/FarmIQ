// lib/models/ngo_model.dart
class NGO {
  final String id;
  final String name;
  final String? description;
  final String? website;
  final String? address;
  final String? city;
  final String state;
  final String? contactEmail;
  final String? contactPhone;

  NGO({
    required this.id,
    required this.name,
    this.description,
    this.website,
    this.address,
    this.city,
    required this.state,
    this.contactEmail,
    this.contactPhone,
  });

  factory NGO.fromJson(Map<String, dynamic> json) {
    return NGO(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name Provided',
      description: json['description'],
      website: json['website'],
      address: json['address'],
      city: json['city'],
      state: json['state'] ?? 'Unknown State',
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
    );
  }
}