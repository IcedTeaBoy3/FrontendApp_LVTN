import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app/models/response_api.dart';
import 'package:frontend_app/models/user.dart';
import 'package:frontend_app/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  AuthProvider() {
    _loadFromStorage();
  }
  User? _user;
  String? _accessToken;
  String? _refreshToken;

  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isAuthenticated => _user != null && _accessToken != null;

  Future<ResponseApi> loginWithGoogle() async {
    try {
      final result = await AuthService.loginWithGoogle();
      if (result.status == 'success') {
        _user = result.user;
        _accessToken = result.accessToken;
        _refreshToken = result.refreshToken;
        // Lưu token và user vào secure storage
        await _storage.write(key: 'accessToken', value: _accessToken);
        await _storage.write(key: 'refreshToken', value: _refreshToken);
        notifyListeners();
      }
      return result;
    } catch (e) {
      return ResponseApi(status: 'error', message: 'Đăng nhập Google thất bại');
    }
  }

  Future<ResponseApi> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await AuthService.login(email: email, password: password);
      if (result.status == 'success') {
        _user = result.user;
        _accessToken = result.accessToken;
        _refreshToken = result.refreshToken;
        // Lưu token và user vào secure storage
        await _storage.write(key: 'accessToken', value: _accessToken);
        await _storage.write(key: 'refreshToken', value: _refreshToken);
        notifyListeners();
      }
      return result;
    } catch (e) {
      return ResponseApi(
        status: 'error',
        message: 'Đăng nhập thất bại',
      );
    }
  }

  Future<void> _loadFromStorage() async {
    _accessToken = await _storage.read(key: 'accessToken');
    print('Token loaded from storage: $_accessToken');
    if (_accessToken != null) {
      bool isExpired = Jwt.isExpired(_accessToken!);
      if (!isExpired) {
        _user = await AuthService.getUser();
      } else {
        _accessToken = null;
        await _storage.delete(key: 'accessToken');
      }
    } else {
      _user = null;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    notifyListeners();
  }
}
