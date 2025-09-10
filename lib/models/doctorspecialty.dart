import 'specialty.dart';

class DoctorSpecialty {
  final String doctorSpecialtyId;
  final String doctorId;
  final int yearsOfExperience;
  final bool isPrimary;
  final Specialty specialty;

  DoctorSpecialty({
    required this.doctorSpecialtyId,
    required this.doctorId,
    required this.yearsOfExperience,
    required this.isPrimary,
    required this.specialty,
  });

  factory DoctorSpecialty.fromJson(Map<String, dynamic> json) {
    return DoctorSpecialty(
      doctorSpecialtyId: json['doctorSpecialtyId'] ?? '',
      doctorId: json['doctor'] ?? '',
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
      isPrimary: json['isPrimary'] ?? false,
      specialty: Specialty.fromJson(json['specialty'] ?? {}),
    );
  }
  static List<DoctorSpecialty> doctorSpecialtiesFromJson(
      List<dynamic> jsonList) {
    return jsonList.map((json) => DoctorSpecialty.fromJson(json)).toList();
  }
}
