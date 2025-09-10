class Clinic {
  final String clinicId;
  final String name;
  final String description;
  final String address;
  final List<String> images;
  final String phone;
  final String? email;
  final String? workHours;
  final List<String>? services;

  Clinic({
    required this.clinicId,
    required this.name,
    required this.address,
    required this.images,
    required this.phone,
    required this.description,
    this.email,
    this.workHours,
    this.services,
  });
  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      clinicId: json['clinicId'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      email: json['email'] ?? '',
      workHours: json['workHours'] ?? '',
      services:
          json['services'] != null ? List<String>.from(json['services']) : null,
    );
  }

  // Convert a Clinic object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'clinicId': clinicId,
      'name': name,
      'address': address,
      'images': images,
      'phone': phone,
      'description': description,
      'email': email,
      'workHours': workHours,
      'services': services,
    };
  }
}
