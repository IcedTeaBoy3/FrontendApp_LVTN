import 'package:frontend_app/models/specialty.dart';

class Service {
  final String serviceId;
  final Specialty specialty;
  final String name;
  final String? description;
  final double price;

  Service({
    required this.serviceId,
    required this.specialty,
    required this.name,
    this.description,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['serviceId'] ?? '',
      specialty: Specialty.fromJson(json['specialty'] ?? {}),
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] != null)
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
    );
  }
  static List<Service> servicesFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Service.fromJson(json)).toList();
  }

  // Convert a Service object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'specialty': specialty.toJson(),
      'name': name,
      'description': description,
      'price': price,
    };
  }
}
