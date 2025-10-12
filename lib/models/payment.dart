import 'package:frontend_app/models/appointment.dart';

class Payment {
  final String paymentId;
  final Appointment? appointment;
  final String? appointmentId;
  final double amount;
  final String method;
  final String paymentType;
  final String status;
  final DateTime? payAt;

  Payment({
    required this.paymentId,
    this.appointment,
    this.appointmentId,
    required this.paymentType,
    required this.amount,
    required this.method,
    required this.status,
    this.payAt,
  });
  factory Payment.fromJson(Map<String, dynamic> json) {
    String? parseAppointmentId;
    Appointment? parseAppointment;
    if (json['appointment'] is String) {
      parseAppointmentId = json['appointment'];
    } else if (json['appointment'] is Map<String, dynamic>) {
      parseAppointment = Appointment.fromJson(json['appointment']);
    }
    return Payment(
      paymentId: json['paymentId'] ?? json['_id'] ?? '',
      appointmentId: parseAppointmentId,
      appointment: parseAppointment,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'],
      status: json['status'],
      payAt: json['payAt'] != null ? DateTime.parse(json['payAt']) : null,
      paymentType: json['paymentType'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'appointment':
          appointment != null ? appointment!.toJson() : appointmentId,
      'amount': amount,
      'method': method,
      'status': status,
      'payAt': payAt?.toIso8601String(),
      'paymentType': paymentType,
    };
  }

  Payment copyWith({
    String? paymentId,
    Appointment? appointment,
    String? appointmentId,
    double? amount,
    String? method,
    String? paymentType,
    String? status,
    DateTime? payAt,
  }) {
    return Payment(
      paymentId: paymentId ?? this.paymentId,
      appointment: appointment ?? this.appointment,
      appointmentId: appointmentId ?? this.appointmentId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      paymentType: paymentType ?? this.paymentType,
      status: status ?? this.status,
      payAt: payAt ?? this.payAt,
    );
  }
}
