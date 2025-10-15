import 'package:frontend_app/models/appointment.dart';
import 'api_client.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app/models/responseapi.dart';
import 'package:frontend_app/models/payment.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';

class AppointmentService {
  static Future<ResponseApi<Appointment>> createAppointment(
      Appointment appointment, Payment payment,
      {File? symptomsImage}) async {
    try {
      final formData = FormData.fromMap({
        'appointment': jsonEncode(appointment.toJson()),
        'payment': jsonEncode(payment.toJson()),
        if (symptomsImage != null)
          'symptomsImage': await MultipartFile.fromFile(
            symptomsImage.path,
            filename: path.basename(symptomsImage.path),
          ),
      });
      final response = await ApiClient.dio.post(
        '/appointment/create-appointment',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      return ResponseApi<Appointment>.fromJson(
        response.data,
        funtionParser: (dataJson) => Appointment.fromJson(dataJson),
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      print('Dio error response: ${e}');
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Tạo hồ sơ thất bại',
      );
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu
      throw Exception('Error: $e');
    }
  }

  static Future<ResponseApi<Appointment>> cancelAppointment(
      String appointmentId) async {
    try {
      final response = await ApiClient.dio.put(
        '/appointment/cancel-appointment/$appointmentId',
        data: {},
      );
      debugPrint('Response data: ${response.data}');
      return ResponseApi<Appointment>.fromJson(
        response.data,
        funtionParser: (dataJson) => Appointment.fromJson(dataJson),
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      print('Dio error response: ${e}');
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Hủy lịch khám thất bại',
      );
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu
      throw Exception('Error: $e');
    }
  }

  static Future<ResponseApi<List<Appointment>>> fetchAppointments(
      {int page = 1, int limit = 10}) async {
    try {
      final response = await ApiClient.dio.get(
        '/appointment/get-account-appointments',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return ResponseApi<List<Appointment>>.fromJson(
        response.data,
        funtionParser: (dataJson) {
          final appointments = dataJson['appointments'] as List;
          return appointments
              .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
