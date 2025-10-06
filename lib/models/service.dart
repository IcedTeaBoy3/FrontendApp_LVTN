import 'package:frontend_app/models/specialty.dart';

class Service {
  final String serviceId;
  final Specialty? specialty;
  final String? specialtyId;
  final String name;
  final String? description;
  final double price;
  final String status;

  Service({
    required this.serviceId,
    this.specialty,
    this.specialtyId,
    required this.name,
    this.description,
    required this.price,
    this.status = 'active',
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    Specialty? parsedSpecialty;
    String? parsedSpecialtyId;
    if (json['specialty'] is Map<String, dynamic>) {
      parsedSpecialty = Specialty.fromJson(json['specialty']);
    } else if (json['specialty'] is String) {
      parsedSpecialtyId = json['specialty'];
    }

    return Service(
      serviceId: json['serviceId'] ?? json['_id'] ?? '',
      specialty: parsedSpecialty,
      specialtyId: parsedSpecialtyId,
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] != null)
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      status: json['status'] ?? 'active',
    );
  }
  static List<Service> servicesFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Service.fromJson(json)).toList();
  }

  // Convert a Service object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'specialty': specialty != null ? specialty!.toJson() : specialtyId,
      'name': name,
      'description': description,
      'price': price,
      'status': status,
    };
  }
}
