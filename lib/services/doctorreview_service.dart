import 'api_client.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app/models/doctorreview.dart';
import 'package:frontend_app/models/responseapi.dart';
import 'package:dio/dio.dart';

class DoctorReviewService {
  static Future<ResponseApi<DoctorReview>> createDoctorReview(
      {required String appointmentId,
      required String comment,
      required String doctorId,
      required double rating}) async {
    try {
      final response = await ApiClient.dio.post(
        '/doctorreview/create-doctor-review',
        data: {
          'appointmentId': appointmentId,
          'comment': comment,
          'doctorId': doctorId,
          'rating': rating,
        },
      );
      debugPrint('response ${response.data}');
      return ResponseApi<DoctorReview>.fromJson(
        response.data,
        funtionParser: (dataJson) => DoctorReview.fromJson(dataJson),
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message:
            e.response?.data['message'] ?? 'Failed to create doctor review',
      );
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu → nhảy vào đây.
      throw Exception('Error: $e');
    }
  }

  static Future<ResponseApi<List<DoctorReview>>> getDoctorReviewsByDoctorId(
      String doctorId) async {
    try {
      final response = await ApiClient.dio.get(
        '/doctorreview/get-doctor-reviews/$doctorId',
      );
      debugPrint('response ${response.data}');
      return ResponseApi<List<DoctorReview>>.fromJson(
        response.data,
        funtionParser: (dataJson) =>
            DoctorReview.doctorReviewsFromJson(dataJson),
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to load doctor reviews',
      );
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu → nhảy vào đây.
      throw Exception('Error: $e');
    }
  }
}
