import 'position.dart';
import 'workplace.dart';

class DoctorWorkplace {
  final String doctorWorkplaceId;
  final String doctorId;
  final Workplace workplace;
  final Position position;
  final bool isPrimary;

  DoctorWorkplace({
    required this.doctorWorkplaceId,
    required this.doctorId,
    required this.workplace,
    required this.position,
    required this.isPrimary,
  });

  factory DoctorWorkplace.fromJson(Map<String, dynamic> json) {
    return DoctorWorkplace(
      doctorWorkplaceId: json['doctorWorkplaceId'] ?? '',
      doctorId: json['doctor'] ?? json['doctorId'] ?? '',
      workplace: Workplace.fromJson(json['workplace'] ?? {}),
      position: Position.fromJson(json['position'] ?? {}),
      isPrimary: json['isPrimary'] ?? false,
    );
  }
  static List<DoctorWorkplace> doctorWorkplacesFromJson(
      List<dynamic> jsonList) {
    return jsonList.map((json) => DoctorWorkplace.fromJson(json)).toList();
  }
}
