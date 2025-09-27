import 'person.dart';

class Patientprofile {
  final String patientProfileId;
  final String idCard;
  final String insuranceCode;
  final String relation;
  final Person person;
  final String accountId;

  Patientprofile({
    required this.patientProfileId,
    required this.idCard,
    required this.insuranceCode,
    required this.relation,
    required this.person,
    required this.accountId,
  });

  factory Patientprofile.fromJson(Map<String, dynamic> json) {
    return Patientprofile(
      patientProfileId: json['patientProfileId'],
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

  Map<String, dynamic> toJson() {
    return {
      'patientProfileId': patientProfileId,
      'idCard': idCard,
      'insuranceCode': insuranceCode,
      'relation': relation,
      'person': person.toJson(),
      'accountId': accountId,
    };
  }
}
