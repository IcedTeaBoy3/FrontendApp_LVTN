import 'api_client.dart';
import 'package:frontend_app/models/account.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frontend_app/models/authresponse.dart';
import 'package:frontend_app/models/responseapi.dart';
import 'package:dio/dio.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '763500997258-mlhs837o79q1ftelhqqi7kp5op7garn9.apps.googleusercontent.com',
  );

  static Future<ResponseApi<AuthResponse>> loginWithGoogle() async {
    try {
      // Nếu muốn lần nào cũng cho chọn tài khoản:
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return ResponseApi(
          status: 'error',
          message: 'Người dùng hủy đăng nhập Google',
        );
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        return ResponseApi(
          status: 'error',
          message: 'Không lấy được idToken từ Google',
        );
      }
      // Gửi token về backend
      final response = await ApiClient.dio.post(
        '/auth/google/mobile',
        data: {'idToken': idToken},
      );

      return ResponseApi<AuthResponse>.fromJson(
        response.data,
        funtionParser: (dataJson) => AuthResponse.fromJson(dataJson),
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Đăng nhập thất bại',
      );
    } catch (e) {
      print("Error in loginWithGoogle: $e");
      return ResponseApi(status: 'error', message: 'Đăng nhập Google thất bại');
    }
  }

  static Future<ResponseApi<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/login',
        data: {
          'identifier': email,
          'password': password,
        },
      );
      return ResponseApi<AuthResponse>.fromJson(
        response.data,
        funtionParser: (dataJson) => AuthResponse.fromJson(dataJson),
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Đăng nhập thất bại',
      );
    } catch (e) {
      return ResponseApi(status: 'error', message: 'Đăng nhập thất bại');
    }
  }

  static Future<ResponseApi> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/register',
        data: {
          'identifier': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );
      return ResponseApi.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Đăng nhập thất bại',
      );
    } catch (e) {
      return ResponseApi(status: 'error', message: 'Đăng ký thất bại');
    }
  }

  static Future<ResponseApi> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      return ResponseApi.fromJson(response.data);
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Xác thực OTP thất bại',
      );
    } catch (e) {
      return ResponseApi(status: 'error', message: 'Xác thực OTP thất bại');
    }
  }

  static Future<ResponseApi> resendOtp({
    required String email,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/resend-otp',
        data: {
          'email': email,
        },
      );
      return ResponseApi.fromJson(response.data);
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Gửi lại OTP thất bại',
      );
    } catch (e) {
      return ResponseApi(status: 'error', message: 'Gửi lại OTP thất bại');
    }
  }

  /// 👉 Lấy thông tin account đã lưu
  static Future<Account?> getAccount() async {
    try {
      final response = await ApiClient.dio.get(
        '/auth/me',
      );
      print("Get account response: ${response.data}");
      if (response.statusCode == 200) {
        return Account.fromJson(response.data['data']);
      }
    } catch (e) {
      print("Error get account: $e");
      return null;
    }
  }
}
