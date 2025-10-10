class Account {
  final String accountId;
  final String userName;
  final String avatar;
  final String email;
  final String phone;
  final String role;
  final String typeLogin;
  final bool isVerified;
  final bool isBlocked;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account({
    required this.accountId,
    required this.userName,
    required this.avatar,
    required this.email,
    required this.phone,
    required this.role,
    required this.typeLogin,
    required this.isVerified,
    required this.isBlocked,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parse từ JSON sang object
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'] ?? json['_id'],
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'],
      typeLogin: json['typeLogin'],
      isVerified: json['isVerified'],
      isBlocked: json['isBlocked'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Convert object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'email': email,
      'avatar': avatar,
      'phone': phone,
      'role': role,
      'typeLogin': typeLogin,
      'isVerified': isVerified,
      'isBlocked': isBlocked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
