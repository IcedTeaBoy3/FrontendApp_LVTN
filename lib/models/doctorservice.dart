import 'service.dart';
import 'doctor.dart';

class DoctorService {
  final String doctorServiceId;
  final Service? service;
  final String? serviceId;
  final Doctor? doctor; // <-- sửa thành Doctor?
  final String? doctorId; // <-- giữ lại nếu chỉ có ID
  final double price;

  DoctorService({
    required this.doctorServiceId,
    required this.service,
    this.serviceId,
    this.doctor,
    this.doctorId,
    required this.price,
  });

  factory DoctorService.fromJson(Map<String, dynamic> json) {
    Doctor? parsedDoctor;
    String? parsedDoctorId;
    if (json['doctor'] is Map<String, dynamic>) {
      parsedDoctor = Doctor.fromJson(json['doctor']);
    } else if (json['doctor'] is String) {
      parsedDoctorId = json['doctor'];
    }

    Service? parsedService;
    String? parsedServiceId;
    if (json['service'] is Map<String, dynamic>) {
      parsedService = Service.fromJson(json['service']);
    } else if (json['service'] is String) {
      parsedServiceId = json['service'];
    }

    return DoctorService(
      doctorServiceId: json['doctorServiceId'] ?? '',
      doctor: parsedDoctor,
      doctorId: parsedDoctorId,
      service: parsedService,
      serviceId: parsedServiceId,
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
      'doctor': doctor != null ? doctor!.toJson() : doctorId,
      'service': service != null ? service!.toJson() : serviceId,
      'price': price,
    };
  }
}
