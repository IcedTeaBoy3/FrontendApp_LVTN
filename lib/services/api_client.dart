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
          if (authProvider.accessToken != null) {
            options.headers["Authorization"] =
                "Bearer ${authProvider.accessToken}";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          print('Full error data: ${e.response?.data}');
          print('Type of data: ${e.response?.data.runtimeType}');
          final data = e.response?.data;

          // 🟢 Check token hết hạn
          if (data is Map<String, dynamic> &&
              data['message']?.toString().toLowerCase() == 'jwt expired') {
            await authProvider.refreshTokenIfNeeded();
            if (authProvider.accessToken != null) {
              try {
                final retryRequest = e.requestOptions;
                retryRequest.headers["Authorization"] =
                    "Bearer ${authProvider.accessToken}";
                final response = await _dio.fetch(retryRequest);
                return handler.resolve(response);
              } catch (retryError) {
                print("❌ Retry request failed: $retryError");
                return handler.next(e);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get dio => _dio;
}
