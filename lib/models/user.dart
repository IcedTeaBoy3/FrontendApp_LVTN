class User {
  final String userId;
  final String? name;
  final String email;
  final String phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? avatar;
  final String? address;
  final String role;

  User({
    required this.userId,
    this.name,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.gender,
    this.avatar,
    this.address,
    required this.role,
  });

  /// Parse từ JSON sang object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'] ?? '',
      avatar: json['avatar'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? '',
    );
  }

  /// Convert object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'avatar': avatar,
      'address': address,
      'role': role,
    };
  }
}
