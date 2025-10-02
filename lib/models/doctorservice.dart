import 'service.dart';

class DoctorService {
  final String doctorServiceId;
  final Service service;
  final String doctor;
  final double price;

  DoctorService({
    required this.doctorServiceId,
    required this.service,
    required this.doctor,
    required this.price,
  });

  factory DoctorService.fromJson(Map<String, dynamic> json) {
    return DoctorService(
      doctorServiceId: json['doctorServiceId'] ?? '',
      doctor: json['doctor'] ?? '',
      service: Service.fromJson(json['service'] ?? {}),
      price: (json['price'] != null)
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
    );
  }
  static List<DoctorService> doctorservicesFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => DoctorService.fromJson(json)).toList();
  }

  // Convert a Doctorservice object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'doctorServiceId': doctorServiceId,
      'doctor': doctor,
      'service': service.toJson(),
      'price': price,
    };
  }
}
