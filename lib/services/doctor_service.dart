import 'package:frontend_app/models/doctor.dart';
import 'api_client.dart';
import 'package:flutter/material.dart';

class DoctorService {
  static Future<Map<String, dynamic>> getAllDoctors(
      {int page = 1, int limit = 10}) async {
    try {
      final response = await ApiClient.dio.get(
        '/doctor/get-all-doctors',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      debugPrint('response ${response.data}');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final doctors = Doctor.doctorsFromJson(data['doctors']);
        final total = data['total'] as int;
        debugPrint('total $total');
        return {
          'doctors': doctors,
          'total': total,
        };
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu → nhảy vào đây.
      throw Exception('Error: $e');
    }
  }
}
