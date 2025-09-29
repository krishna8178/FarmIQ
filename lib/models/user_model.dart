class User {
  final String id;
  final String name;
  final String email;
  final String? mobile; // Mobile is optional and can be null

  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
  });

  // This is a factory constructor. Its job is to create a User object
  // by parsing the JSON data you get from your server.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Your server sends the user ID as '_id', so we map it to 'id' here.
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'], // This will be null if the server doesn't send it
    );
  }
}
