import 'package:flutter/material.dart';

String converStatusAppointment(String status) {
  switch (status) {
    case 'pending':
      return 'Chờ xác nhận';
    case 'confirmed':
      return 'Đã xác nhận';
    case 'completed':
      return 'Đã hoàn thành';
    case 'cancelled':
      return 'Đã hủy';
    default:
      return status;
  }
}

Icon getStatusIconAppointment(String status) {
  switch (status) {
    case 'pending':
      return const Icon(Icons.hourglass_empty, color: Colors.white);
    case 'confirmed':
      return const Icon(Icons.check_circle, color: Colors.white);
    case 'completed':
      return const Icon(Icons.check_circle_outline, color: Colors.white);
    case 'cancelled':
      return const Icon(Icons.cancel, color: Colors.white);
    default:
      return const Icon(Icons.help_outline, color: Colors.white);
  }
}

Color getStatusColorAppointment(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'confirmed':
      return Colors.blue;
    case 'completed':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
