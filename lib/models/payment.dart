import 'package:frontend_app/models/appointment.dart';

class Payment {
  final String paymentId;
  final Appointment appointment;
  final double amount;
  final String method;
  final String paymentType;
  final String status;
  final DateTime? payAt;

  Payment({
    required this.paymentId,
    required this.appointment,
    required this.paymentType,
    required this.amount,
    required this.method,
    required this.status,
    this.payAt,
  });
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['paymentId'] ?? json['_id'] ?? '',
      appointment: Appointment.fromJson(json['appointment']),
      amount: (json['amount'] as num).toDouble(),
      method: json['method'],
      status: json['status'],
      payAt: DateTime.parse(json['payAt']),
      paymentType: json['paymentType'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'appointment': appointment.toJson(),
      'amount': amount,
      'method': method,
      'status': status,
      'payAt': payAt?.toIso8601String(),
      'paymentType': paymentType,
    };
  }
}
