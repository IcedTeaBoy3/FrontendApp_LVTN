class Ethnic {
  final String code;
  final String name;

  Ethnic({required this.code, required this.name});

  factory Ethnic.fromJson(Map<String, dynamic> json) {
    return Ethnic(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }
  // ✅ override để Flutter biết cách so sánh 2 Ethnic
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ethnic && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}
