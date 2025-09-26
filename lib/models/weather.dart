// lib/models/weather.dart

class Weather {
  final String description;
  final String icon;
  final double temp;
  final double feelsLike;
  final String locationName;

  Weather({
    required this.description,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.locationName,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String locationName) {
    return Weather(
      description: json['description'] ?? 'N/A',
      icon: json['icon'] ?? '',
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      locationName: locationName,
    );
  }
}