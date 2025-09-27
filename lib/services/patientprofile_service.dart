import 'package:frontend_app/models/patientprofile.dart';
import 'api_client.dart';
import 'package:flutter/material.dart';

class PatientprofileService {
  static Future<List<Patientprofile>> getAllUserPatientProfiles(
      {int page = 1, int limit = 10}) async {
    try {
      final response = await ApiClient.dio.get(
        '/patientprofile/get-user-patientprofiles',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      debugPrint('response profile ${response.data}');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final patientprofiles =
            Patientprofile.patientprofilesFromJson(data['patientprofiles']);
        return patientprofiles;
      } else {
        throw Exception('Failed to load patientprofiles');
      }
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu → nhảy vào đây.
      throw Exception('Error: $e');
    }
  }
}
