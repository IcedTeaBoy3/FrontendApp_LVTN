import 'package:dio/dio.dart';
import '../configs/api_config.dart';
import 'package:frontend_app/providers/auth_provider.dart';

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
  static void init(AuthProvider authProvider) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = authProvider.accessToken;
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Nếu token hết hạn có thể refresh token ở đây
          await authProvider.logout();
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get dio => _dio;
}
