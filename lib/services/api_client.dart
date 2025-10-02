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
          if (authProvider.accessToken != null) {
            options.headers["Authorization"] =
                "Bearer ${authProvider.accessToken}";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          print("Dio error: ${e.message}");
          print("Dio error response: ${e.response?.data}");
          print("Dio error status code: ${e.response?.statusCode}");
          if (e.response?.statusCode == 401) {
            await authProvider.refreshTokenIfNeeded();
            if (authProvider.accessToken != null) {
              final retryRequest = e.requestOptions;
              retryRequest.headers["Authorization"] =
                  "Bearer ${authProvider.accessToken}";
              final response = await _dio.fetch(retryRequest);
              return handler.resolve(response);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get dio => _dio;
}
