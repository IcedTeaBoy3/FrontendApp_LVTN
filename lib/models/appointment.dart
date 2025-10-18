import 'doctorservice.dart';
import 'patientprofile.dart';
import 'slot.dart';
import 'schedule.dart';
import 'payment.dart';

class Appointment {
  final String appointmentId;
  final String? appointmentCode;
  final int? appointmentNumber;
  final Patientprofile? patientProfile;
  final String? patientProfileId;
  final DoctorService? doctorService;
  final String? doctorServiceId;
  final Schedule? schedule;
  final String? scheduleId;
  final Slot? slot;
  final String? slotId;
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
    this.patientProfileId,
    required this.doctorService,
    this.doctorServiceId,
    required this.schedule,
    this.scheduleId,
    required this.slot,
    this.slotId,
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
    String? parsePatientProfileId;
    Patientprofile? parsePatientProfile;
    String? parseDoctorServiceId;
    DoctorService? parseDoctorService;
    String? parseScheduleId;
    Schedule? parseSchedule;
    String? parseSlotId;
    Slot? parseSlot;

    final paymentData = json['payment'];
    final patientProfileData = json['patientProfile'];
    final doctorServiceData = json['doctorService'];
    final scheduleData = json['schedule'];
    final slotData = json['slot'];

    if (paymentData != null) {
      if (paymentData is String) {
        parsePaymentId = paymentData;
      } else if (paymentData is Map<String, dynamic>) {
        parsePayment = Payment.fromJson(paymentData);
      }
    }
    if (patientProfileData != null) {
      if (patientProfileData is String) {
        parsePatientProfileId = patientProfileData;
      } else if (patientProfileData is Map<String, dynamic>) {
        parsePatientProfile = Patientprofile.fromJson(patientProfileData);
      }
    }
    if (doctorServiceData != null) {
      if (doctorServiceData is String) {
        parseDoctorServiceId = doctorServiceData;
      } else if (doctorServiceData is Map<String, dynamic>) {
        parseDoctorService = DoctorService.fromJson(doctorServiceData);
      }
    }
    if (scheduleData != null) {
      if (scheduleData is String) {
        parseScheduleId = scheduleData;
      } else if (scheduleData is Map<String, dynamic>) {
        parseSchedule = Schedule.fromJson(scheduleData);
      }
    }
    if (slotData != null) {
      if (slotData is String) {
        parseSlotId = slotData;
      } else if (slotData is Map<String, dynamic>) {
        parseSlot = Slot.fromJson(slotData);
      }
    }

    return Appointment(
      appointmentNumber: json['appointmentNumber'] ?? '',
      appointmentCode: json['appointmentCode'] ?? '',
      appointmentId: json['appointmentId'] ?? json['_id'] ?? '',
      paymentId: parsePaymentId,
      payment: parsePayment,
      doctorService: parseDoctorService,
      doctorServiceId: parseDoctorServiceId,
      patientProfile: parsePatientProfile,
      patientProfileId: parsePatientProfileId,
      schedule: parseSchedule,
      scheduleId: parseScheduleId,
      slot: parseSlot,
      slotId: parseSlotId,
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt']).toLocal()
          : null,
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
      'doctorService': doctorService?.toJson(),
      'doctorServiceId': doctorServiceId,
      'patientProfile': patientProfile?.toJson(),
      'patientProfileId': patientProfileId,
      'schedule': schedule?.toJson(),
      'scheduleId': scheduleId,
      'slot': slot?.toJson(),
      'slotId': slotId,
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
