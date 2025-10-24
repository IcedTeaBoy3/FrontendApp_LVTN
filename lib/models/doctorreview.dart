import 'appointment.dart';
import 'doctor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorReview {
  final String doctorReviewId;
  final Doctor? doctor;
  final String? doctorId;
  final Appointment? appointment;
  final String? appointmentId;
  final String comment;
  final double rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DoctorReview({
    required this.doctorReviewId,
    required this.doctor,
    this.doctorId,
    this.appointment,
    this.appointmentId,
    required this.comment,
    required this.rating,
    required this.createdAt,
    this.updatedAt,
  });

  /// Parse từ JSON sang object
  factory DoctorReview.fromJson(Map<String, dynamic> json) {
    Doctor? parsedDoctor;
    String? parsedDoctorId;
    if (json['doctor'] is Map<String, dynamic>) {
      parsedDoctor = Doctor.fromJson(json['doctor']);
    } else if (json['doctor'] is String) {
      parsedDoctorId = json['doctor'];
    }
    Appointment? parsedAppointment;
    String? parsedAppointmentId;
    if (json['appointment'] is Map<String, dynamic>) {
      parsedAppointment = Appointment.fromJson(json['appointment']);
    } else if (json['appointment'] is String) {
      parsedAppointmentId = json['appointment'];
    }
    return DoctorReview(
        doctorReviewId: json['doctorReviewId'] ?? json['_id'] ?? '',
        doctor: parsedDoctor,
        doctorId: parsedDoctorId,
        appointment: parsedAppointment,
        appointmentId: parsedAppointmentId,
        comment: json['comment'] ?? '',
        rating: json['rating']?.toDouble() ?? 0.0,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt']).toLocal()
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt']).toLocal()
            : null);
  }

  /// Parse từ JSON List sang List<Object>
  static List<DoctorReview> doctorReviewsFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => DoctorReview.fromJson(json)).toList();
  }

  // Copy với các thuộc tính khác nếu cần
  DoctorReview copyWith({
    String? doctorReviewId,
    Doctor? doctor,
    String? doctorId,
    Appointment? appointment,
    String? appointmentId,
    String? comment,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoctorReview(
      doctorReviewId: doctorReviewId ?? this.doctorReviewId,
      doctor: doctor ?? this.doctor,
      doctorId: doctorId ?? this.doctorId,
      appointment: appointment ?? this.appointment,
      appointmentId: appointmentId ?? this.appointmentId,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
