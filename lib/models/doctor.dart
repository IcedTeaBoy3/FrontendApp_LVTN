import 'user.dart';
import 'degree.dart';
import 'doctorspecialty.dart';

class Doctor {
  final String doctorId;
  final User user;
  final Degree degree;
  final String? bio;
  final String? notes;
  final List<DoctorSpecialty> doctorSpecialties;

  Doctor({
    required this.doctorId,
    required this.user,
    required this.degree,
    required this.doctorSpecialties,
    this.bio,
    this.notes,
  });

  /// Parse từ JSON sang object
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctorId'] as String,
      user: User.fromJson(json['user']),
      degree: Degree.fromJson(json['degree']),
      bio: json['bio'] ?? '',
      notes: json['notes'] ?? '',
      doctorSpecialties: json['doctorSpecialties'] != null
          ? DoctorSpecialty.doctorSpecialtiesFromJson(json['doctorSpecialties'])
          : [],
    );
  }
  static List<Doctor> doctorsFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Doctor.fromJson(json)).toList();
  }

// Lấy chuyên khoa chính
  String get primarySpecialtyName {
    final primary = doctorSpecialties.firstWhere(
      (e) => e.isPrimary == true,
    );
    return primary.specialty.name;
  }

  /// Convert object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'user': user.toJson(),
      'degree': degree.toJson(),
      'bio': bio,
      'notes': notes,
    };
  }
}
