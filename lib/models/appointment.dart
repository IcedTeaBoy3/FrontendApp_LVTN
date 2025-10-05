import 'doctorservice.dart';
import 'patientprofile.dart';
import 'slot.dart';
import 'schedule.dart';
import 'payment.dart';

class Appointment {
  final String appointmentId;
  final String? appointmentCode;
  final int? appointmentNumber;
  final Patientprofile patientProfile;
  final DoctorService doctorService;
  final Schedule schedule;
  final Slot slot;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Payment? payment;
  final String? paymentId;

  Appointment({
    this.appointmentNumber,
    this.appointmentCode,
    required this.appointmentId,
    required this.patientProfile,
    required this.doctorService,
    required this.schedule,
    required this.slot,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.payment,
    this.paymentId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    String? parsePaymentId;
    Payment? parsePayment;
    if (json['payment'] is String) {
      parsePaymentId = json['payment'];
    } else if (json['payment'] is Map<String, dynamic>) {
      parsePayment = Payment.fromJson(json['payment']);
    }

    return Appointment(
      appointmentNumber: json['appointmentNumber'] ?? '',
      appointmentCode: json['appointmentCode'] ?? '',
      appointmentId: json['appointmentId'] ?? json['_id'] ?? '',
      paymentId: parsePaymentId,
      payment: parsePayment,
      doctorService: DoctorService.fromJson(json['doctorService']),
      patientProfile: Patientprofile.fromJson(json['patientProfile']),
      schedule: Schedule.fromJson(json['schedule']),
      slot: Slot.fromJson(json['slot']),
      status: json['status'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
  static List<Appointment> appointmentsFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Appointment.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'appointmentCode': appointmentCode,
      'appointmentNumber': appointmentNumber,
      'doctorService': doctorService.toJson(),
      'patientProfile': patientProfile.toJson(),
      'schedule': schedule.toJson(),
      'slot': slot.toJson(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
