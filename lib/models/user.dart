class User {
  final String id;
  final String name;
  final String email;
  final String mobile; // Mobile is optional and can be null

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  // This factory constructor creates a User object from JSON data.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Your server sends the user ID as '_id', so we map it to 'id' here.
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'User', // Default to 'User' if name is null
      email: json['email'] as String? ?? '',
      mobile: json['phone'] as String? ?? '', // This will be null if not provided
    );
  }
}