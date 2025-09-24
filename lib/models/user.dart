class User {
  final String userId;
  final String? name;
  final String email;
  final String? avatar;
  final String role;
  final String type;
  final String phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.userId,
    this.name,
    this.avatar,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.gender,
    this.address,
    required this.role,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parse từ JSON sang object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      role: json['role'] ?? '',
      type: json['type'] ?? '',
      phone: json['phone'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
