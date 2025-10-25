import 'package:frontend_app/models/service.dart';

class Clinic {
  final String clinicId;
  final String name;
  final String description;
  final String? criteria;
  final String address;
  final List<String> images;
  final String phone;
  final String? email;
  final String? website;
  final String? workHours;
  final List<Service>? services;

  Clinic({
    required this.clinicId,
    required this.criteria,
    required this.name,
    required this.address,
    required this.images,
    required this.phone,
    required this.description,
    this.email,
    this.website,
    this.workHours,
    this.services,
  });
  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      clinicId: json['clinicId'] ?? '',
      criteria: json['criteria'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      workHours: json['workHours'] ?? '',
      services: json['services'] != null
          ? (json['services'] as List)
              .map((serviceJson) => Service.fromJson(serviceJson))
              .toList()
          : null,
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
      'website': website,
      'workHours': workHours,
      'services': services,
    };
  }
}
