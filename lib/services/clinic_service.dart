import 'package:flutter/material.dart';
import 'package:frontend_app/models/clinic.dart';
import 'api_client.dart';

class ClinicService {
  static Future<Clinic> getClinic() async {
    try {
      final response = await ApiClient.dio.get(
        '/clinic/get-clinic',
      );
      debugPrint(
          'Response data: ${response.data}'); // In dữ liệu nhận được để kiểm tra
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final clinic = Clinic.fromJson(data);
        return clinic;
      } else {
        throw Exception('Failed to load clinics');
      }
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu → nhảy vào đây.
      throw Exception('Error: $e');
    }
  }
}
