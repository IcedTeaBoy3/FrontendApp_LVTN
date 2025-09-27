import 'api_client.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/responseapi.dart';
import 'package:dio/dio.dart';

class PatientprofileService {
  static Future<ResponseApi<List<Patientprofile>>> getAllUserPatientProfiles(
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
      return ResponseApi<List<Patientprofile>>.fromJson(
        response.data,
        funtionParser: (dataJson) {
          final profiles = dataJson['patientprofiles'] as List;
          return profiles
              .map((e) => Patientprofile.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      throw Exception(
          e.response?.data['message'] ?? 'Failed to load patientprofiles');
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu → nhảy vào đây.
      throw Exception('Error: $e');
    }
  }

  static Future<ResponseApi<Patientprofile>> createPatientProfile(
      Patientprofile patientprofile) async {
    try {
      debugPrint('Creating patient profile: ${patientprofile.toJson()}');
      final response = await ApiClient.dio.post(
        '/patientprofile/create-patientprofile',
        data: patientprofile.toJson(),
      );
      debugPrint('response create profile ${response.data}');

      return ResponseApi<Patientprofile>.fromJson(
        response.data,
        funtionParser: (dataJson) => Patientprofile.fromJson(dataJson),
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Đăng nhập thất bại',
      );
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu
      throw Exception('Error: $e');
    }
  }

  static Future<ResponseApi> deletePatientProfile(String id) async {
    try {
      debugPrint('Deleting patient profile with id: $id');
      final response = await ApiClient.dio.delete(
        '/patientprofile/delete-patientprofile/$id',
      );
      debugPrint('response delete profile ${response.data}');

      return ResponseApi.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Xóa hồ sơ thất bại',
      );
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu
      throw Exception('Error: $e');
    }
  }
}
