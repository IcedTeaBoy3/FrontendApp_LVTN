import 'appointment.dart';

class MedicalResult {
  final String medicalResultId;
  final Appointment? appointment; // Tham chiếu tới thông tin lịch khám
  final String? appointmentId;
  final String? diagnosis; // Chẩn đoán
  final String? prescription; // Toa thuốc
  final String? notes; // Ghi chú
  final List<String>? attachments; // Danh sách file kết quả (ảnh, pdf, ...)

  MedicalResult({
    required this.medicalResultId,
    this.appointment,
    this.appointmentId,
    this.diagnosis,
    this.prescription,
    this.notes,
    this.attachments,
  });

  factory MedicalResult.fromJson(Map<String, dynamic> json) {
    String? parseAppointmentId;
    Appointment? parseAppointment;

    if (json['appointment'] is String) {
      parseAppointmentId = json['appointment'];
    } else if (json['appointment'] is Map<String, dynamic>) {
      parseAppointment = Appointment.fromJson(json['appointment']);
    }

    return MedicalResult(
      medicalResultId: json['_id'] ?? json['medicalResultId'] ?? '',
      appointment: parseAppointment,
      appointmentId: parseAppointmentId,
      diagnosis: json['diagnosis'],
      prescription: json['prescription'],
      notes: json['notes'],
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicalResultId': medicalResultId,
      'appointment': appointment?.toJson(),
      'diagnosis': diagnosis,
      'prescription': prescription,
      'notes': notes,
      'attachments': attachments,
    };
  }

  static List<MedicalResult> medicalResultsFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => MedicalResult.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
