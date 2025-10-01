import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../configs/api_config.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  static final CookieJar _cookieJar = CookieJar(); // Bộ nhớ cookie

  static void init(AuthProvider authProvider) {
    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = FlutterSecureStorage();
          final token = await storage.read(key: 'accessToken');
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          print("Dio error: ${e.message}");
          print("Dio error response: ${e.response?.data}");
          print("Dio error status code: ${e.response?.statusCode}");
          if (e.response?.statusCode == 401) {
            await authProvider.refreshTokenIfNeeded();
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get dio => _dio;
}
