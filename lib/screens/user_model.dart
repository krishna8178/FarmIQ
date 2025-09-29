class User {
  final String id;
  final String name;
  final String email;
  final String? mobile; // Mobile is optional

  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
  });

  // A factory constructor to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}