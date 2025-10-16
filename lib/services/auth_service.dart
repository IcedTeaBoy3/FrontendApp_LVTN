import 'package:flutter/material.dart';

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
    required String type, // "register" hoặc "forgotPassword"
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/verify-otp',
        data: {
          'email': email,
          'otp': otp,
          'type': type,
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
    required String type, // "register" hoặc "forgotPassword"
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/resend-otp',
        data: {
          'email': email,
          'type': type,
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

  static Future<ResponseApi> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/forgot-password',
        data: {
          'email': email,
        },
      );
      return ResponseApi.fromJson(response.data);
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Quên mật khẩu thất bại',
      );
    } catch (e) {
      return ResponseApi(status: 'error', message: 'Quên mật khẩu thất bại');
    }
  }

  static Future<ResponseApi> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/reset-password',
        data: {
          'email': email,
          'newPassword': newPassword,
        },
      );
      return ResponseApi.fromJson(response.data);
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Đặt lại mật khẩu thất bại',
      );
    } catch (e) {
      return ResponseApi(status: 'error', message: 'Đặt lại mật khẩu thất bại');
    }
  }

  static Future<Account?> getAccount() async {
    try {
      final response = await ApiClient.dio.get(
        '/auth/me',
      );
      if (response.statusCode == 200) {
        return Account.fromJson(response.data['data']);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<ResponseApi<AuthResponse>> refreshToken(String token) async {
    try {
      final response = await ApiClient.dio.post(
        '/auth/mobile-refresh-token',
        data: {'refreshToken': token},
      );
      print('response refreshToken ${response.data}');
      return ResponseApi<AuthResponse>.fromJson(
        response.data,
        funtionParser: (dataJson) => AuthResponse.fromJson(dataJson),
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Làm mới token thất bại',
      );
    } catch (e) {
      return ResponseApi(
        status: 'error',
        message: 'Làm mới token thất bại',
      );
    }
  }

  static Future<ResponseApi<Account>> updateAccount({
    required String accountId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final formData = FormData.fromMap(updatedData);
      final response = await ApiClient.dio.put(
        '/account/update-account/$accountId',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      debugPrint('Response data: ${response.data}');
      return ResponseApi<Account>.fromJson(
        response.data,
        funtionParser: (dataJson) => Account.fromJson(dataJson),
      );
    } on DioException catch (e) {
      // 👇 Lấy message từ server nếu có
      return ResponseApi(
        status: 'error',
        message: e.response?.data['message'] ?? 'Cập nhật thông tin thất bại',
      );
    } catch (e) {
      return ResponseApi(
          status: 'error', message: 'Cập nhật thông tin thất bại');
    }
  }
}
