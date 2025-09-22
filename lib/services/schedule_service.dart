import 'package:flutter/material.dart';
import 'package:frontend_app/models/schedule.dart';
import 'package:intl/intl.dart';
import 'api_client.dart';

class ScheduleService {
  static Future<Map<String, dynamic>> getAllDoctorSchedules(
      {required String doctorId, DateTime? date}) async {
    try {
      print('Fetching schedules for doctorId: $doctorId, date: $date');
      final year = date?.year;
      final month = date?.month;
      final response = await ApiClient.dio
          .get('/schedule/get-schedules-by-doctor/$doctorId', queryParameters: {
        'year': year,
        'month': month,
      });
      debugPrint('Response data: ${response.data}');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final schedules = Schedule.schedulesFromJson(data['schedules']);
        final total = data['total'] as int;
        return {
          'schedules': schedules,
          'total': total,
        };
      } else {
        throw Exception('Failed to load doctor schedules');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
