import 'package:frontend_app/models/doctorworkplace.dart';
import 'package:frontend_app/models/person.dart';

import 'account.dart';
import 'degree.dart';
import 'doctorspecialty.dart';
import 'doctorservice.dart';

class Doctor {
  final String doctorId;
  final Account? account;
  final String? accountId;
  final Person person;
  final Degree? degree;
  final String? degreeId;
  final String? bio;
  final String? notes;
  final List<DoctorSpecialty> doctorSpecialties;
  final List<DoctorWorkplace> doctorWorplaces;
  final List<DoctorService> doctorServices;

  Doctor({
    required this.doctorId,
    this.account,
    this.accountId,
    required this.person,
    this.degree,
    this.degreeId,
    required this.doctorSpecialties,
    required this.doctorWorplaces,
    required this.doctorServices,
    this.bio,
    this.notes,
  });

  /// Parse từ JSON sang object
  factory Doctor.fromJson(Map<String, dynamic> json) {
    Account? parsedAccount;
    String? parsedAccountId;
    if (json['account'] is Map<String, dynamic>) {
      parsedAccount = Account.fromJson(json['account']);
    } else if (json['account'] is String) {
      parsedAccountId = json['account'];
    }
    Degree? parsedDegree;
    String? parsedDegreeId;
    if (json['degree'] is Map<String, dynamic>) {
      parsedDegree = Degree.fromJson(json['degree']);
    } else if (json['degree'] is String) {
      parsedDegreeId = json['degree'];
    }
    return Doctor(
      doctorId: json['doctorId'] ?? json['_id'] ?? '',
      account: parsedAccount,
      accountId: parsedAccountId,
      degree: parsedDegree,
      degreeId: parsedDegreeId,
      person: Person.fromJson(json['person']),
      bio: json['bio'] ?? '',
      notes: json['notes'] ?? '',
      doctorSpecialties: json['doctorSpecialties'] != null
          ? DoctorSpecialty.doctorSpecialtiesFromJson(json['doctorSpecialties'])
          : [],
      doctorWorplaces: json['doctorWorkplaces'] != null
          ? DoctorWorkplace.doctorWorkplacesFromJson(json['doctorWorkplaces'])
          : [],
      doctorServices: json['doctorServices'] != null
          ? DoctorService.doctorservicesFromJson(json['doctorServices'])
          : [],
    );
  }
  static List<Doctor> doctorsFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Doctor.fromJson(json)).toList();
  }

  /// Lấy chuyên khoa chính
  String get primarySpecialtyName {
    if (doctorSpecialties.isEmpty) {
      return 'Chưa cập nhật';
    }

    final primary = doctorSpecialties.firstWhere(
      (e) => e.isPrimary == true,
      orElse: () => doctorSpecialties.first,
    );

    return primary.specialty.name;
  }

  // Lấy năm kinh nghiệm của chuyên khoa chính
  int get yearsOfExperience {
    if (doctorSpecialties.isEmpty) return 0;

    final primary = doctorSpecialties.firstWhere(
      (e) => e.isPrimary,
      orElse: () => doctorSpecialties.first,
    );

    return primary.yearsOfExperience;
  }

  // Lấy nơi làm việc chính
  String get primaryWorkplaceName {
    if (doctorWorplaces.isEmpty) return "Chưa cập nhật";

    final primary = doctorWorplaces.firstWhere(
      (e) => e.isPrimary == true,
      orElse: () => doctorWorplaces.first,
    );

    return primary.workplace.name;
  }

  // Lấy chức vụ của nơi làm việc chính
  String get primaryPositionName {
    if (doctorWorplaces.isEmpty) return "Chưa cập nhật";

    final primary = doctorWorplaces.firstWhere(
      (e) => e.isPrimary == true,
      orElse: () => doctorWorplaces.first,
    );

    return primary.position.title;
  }

  /// Convert object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'account': account != null ? account!.toJson() : accountId,
      'person': person.toJson(),
      'degree': degree != null ? degree!.toJson() : degreeId,
      'bio': bio,
      'notes': notes,
    };
  }
}
