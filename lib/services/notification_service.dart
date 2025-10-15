import 'package:flutter/material.dart';
import 'package:frontend_app/models/notification.dart';
import 'package:frontend_app/models/responseapi.dart';
import 'api_client.dart';

class NotificationService {
  static Future<ResponseApi<List<NotificationModel>>> getAllNotifications(
      {int page = 1, int limit = 100}) async {
    try {
      final response = await ApiClient.dio
          .get('/notification/get-all-notifications', queryParameters: {
        'page': page,
        'limit': limit,
      });
      debugPrint('Response data: ${response.data}');
      return ResponseApi<List<NotificationModel>>.fromJson(
        response.data,
        funtionParser: (dataJson) {
          final notifications = dataJson['notifications'] as List<dynamic>;
          return notifications
              .map((item) => NotificationModel.fromJson(item))
              .toList();
        },
      );
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<ResponseApi> markAllAsRead() async {
    try {
      final response =
          await ApiClient.dio.put('/notification/mark-all-as-read', data: {});
      debugPrint('Response data: ${response.data}');
      return ResponseApi.fromJson(response.data);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<ResponseApi> deleteAllNotifications() async {
    try {
      final response =
          await ApiClient.dio.delete('/notification/clear-all-notifications');
      debugPrint('Response data: ${response.data}');
      return ResponseApi.fromJson(response.data);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
