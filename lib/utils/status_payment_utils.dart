import 'package:flutter/material.dart';

Icon getStatusIconPayment(String status) {
  if (status == 'paid') {
    return Icon(Icons.check_circle, color: Colors.white);
  }
  return Icon(Icons.hourglass_empty, color: Colors.white);
}

Color getStatusColorPayment(String status) {
  if (status == 'paid') {
    return Colors.green;
  } else {
    return Colors.orange;
  }
}

String converStatusPayment(String status) {
  if (status == 'paid') {
    return 'Đã thanh toán';
  }
  return 'Chưa thanh toán';
}
