class Person {
  final String? avatar;
  final String fullName;
  final String address;
  final String gender;
  final DateTime dateOfBirth;
  final String? phone;
  final String? ethnic;
  final String? job;

  Person({
    this.avatar,
    required this.fullName,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    this.phone,
    this.ethnic,
    this.job,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      avatar: json['avatar'] ?? '',
      fullName: json['name'] ?? json['fullName'],
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      phone: json['phone'] ?? '',
      ethnic: json['ethnic'] ?? '',
      job: json['job'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'fullName': fullName,
      'address': address,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'phone': phone,
      'ethnic': ethnic,
      'job': job
    };
  }
}
