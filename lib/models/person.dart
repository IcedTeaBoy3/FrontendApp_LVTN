class Person {
  final String? avatar;
  final String? fullName;
  final String? address;
  final String? gender;
  final DateTime? dateOfBirth;

  Person({
    this.avatar,
    this.fullName,
    this.address,
    this.gender,
    this.dateOfBirth,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      avatar: json['avatar'] ?? '',
      fullName: json['name'] ?? json['fullName'],
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'fullName': fullName,
      'address': address,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }
}
