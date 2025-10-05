import 'person.dart';

class Patientprofile {
  final String patientProfileId;
  final String patientProfileCode;
  final String idCard;
  final String insuranceCode;
  final String relation;
  final Person person;
  final String accountId;

  Patientprofile({
    required this.patientProfileId,
    required this.patientProfileCode,
    required this.idCard,
    required this.insuranceCode,
    required this.relation,
    required this.person,
    required this.accountId,
  });

  factory Patientprofile.fromJson(Map<String, dynamic> json) {
    return Patientprofile(
      patientProfileId: json['patientProfileId'],
      patientProfileCode: json['patientProfileCode'] ?? '',
      idCard: json['idCard'] ?? '',
      insuranceCode: json['insuranceCode'] ?? '',
      relation: json['relation'],
      person: Person.fromJson(json['person']),
      accountId: json['accountId'] ?? json['account'],
    );
  }
  static List<Patientprofile> patientprofilesFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Patientprofile.fromJson(json)).toList();
  }

  // copyWith method for updating fields
  Patientprofile copyWith({
    String? patientProfileId,
    String? patientProfileCode,
    String? idCard,
    String? insuranceCode,
    String? relation,
    Person? person,
    String? accountId,
  }) {
    return Patientprofile(
      patientProfileId: patientProfileId ?? this.patientProfileId,
      patientProfileCode: patientProfileCode ?? this.patientProfileCode,
      idCard: idCard ?? this.idCard,
      insuranceCode: insuranceCode ?? this.insuranceCode,
      relation: relation ?? this.relation,
      person: person ?? this.person,
      accountId: accountId ?? this.accountId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientProfileId': patientProfileId,
      'patientProfileCode': patientProfileCode,
      'idCard': idCard,
      'insuranceCode': insuranceCode,
      'relation': relation,
      'person': person.toJson(),
      'accountId': accountId,
    };
  }
}
