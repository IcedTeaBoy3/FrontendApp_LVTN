import 'package:frontend_app/models/specialty.dart';
import 'api_client.dart';

class SpecialtyService {
  static Future<Map<String, dynamic>> getAllSpecialties(
      {int page = 1, int limit = 10}) async {
    try {
      final response = await ApiClient.dio.get(
        '/specialty/get-all-specialties',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final specialties = Specialty.specialtiesFromJson(data['specialties']);
        final total = data['total'] as int;
        return {
          'specialties': specialties,
          'total': total,
        };
      } else {
        throw Exception('Failed to load specialties');
      }
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API hoặc parse dữ liệu → nhảy vào đây.
      throw Exception('Error: $e');
    }
  }
}
