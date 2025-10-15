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
  final String? symptoms;
  final String? symptomImage;

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
    this.symptoms,
    this.symptomImage,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    String? parsePaymentId;
    Payment? parsePayment;
    final paymentData = json['payment'];
    if (paymentData != null) {
      if (paymentData is String) {
        parsePaymentId = paymentData;
      } else if (paymentData is Map<String, dynamic>) {
        parsePayment = Payment.fromJson(paymentData);
      }
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
      symptoms: json['symptoms'] ?? '',
      symptomImage: json['symptomImage'] ?? '',
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
      'symptoms': symptoms,
      'symptomImage': symptomImage,
    };
  }

  Appointment copyWith({
    String? appointmentId,
    String? appointmentCode,
    int? appointmentNumber,
    Patientprofile? patientProfile,
    DoctorService? doctorService,
    Schedule? schedule,
    Slot? slot,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Payment? payment,
    String? paymentId,
    String? symptoms,
    String? symptomImage,
  }) {
    return Appointment(
      appointmentId: appointmentId ?? this.appointmentId,
      appointmentCode: appointmentCode ?? this.appointmentCode,
      appointmentNumber: appointmentNumber ?? this.appointmentNumber,
      patientProfile: patientProfile ?? this.patientProfile,
      doctorService: doctorService ?? this.doctorService,
      schedule: schedule ?? this.schedule,
      slot: slot ?? this.slot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      payment: payment ?? this.payment,
      paymentId: paymentId ?? this.paymentId,
      symptoms: symptoms ?? this.symptoms,
      symptomImage: symptomImage ?? this.symptomImage,
    );
  }
}
