import 'package:dio/dio.dart';
import '../configs/api_config.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.apiUrl,
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static Dio get dio => _dio;
}
