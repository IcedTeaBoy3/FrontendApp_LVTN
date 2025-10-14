import 'package:flutter/material.dart';
import 'package:frontend_app/models/authresponse.dart';
import 'package:frontend_app/models/responseapi.dart';
import 'package:frontend_app/models/account.dart';
import 'package:frontend_app/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  AuthProvider() {
    _loadFromStorage();
  }
  Account? _account;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;

  Account? get account => _account;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _account != null && _accessToken != null;

  Future<ResponseApi<AuthResponse>> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await AuthService.loginWithGoogle();
      if (result.status == 'success') {
        _account = result.data?.account;
        _accessToken = result.data?.accessToken;
        _refreshToken = result.data?.refreshToken;
        // Lưu token và account vào secure storage
        await _storage.write(key: 'accessToken', value: _accessToken);
        await _storage.write(key: 'refreshToken', value: _refreshToken);
      }
      return result;
    } catch (e) {
      return ResponseApi(status: 'error', message: 'Đăng nhập Google thất bại');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshTokenIfNeeded() async {
    if (_refreshToken == null) return;
    try {
      final result = await AuthService.refreshToken(_refreshToken!);
      if (result.status == 'success') {
        _accessToken = result.data?.accessToken;
        await _storage.write(key: 'accessToken', value: _accessToken);
        notifyListeners();
      } else {
        await logout();
      }
    } catch (e) {
      await logout();
    }
  }

  Future<ResponseApi<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await AuthService.login(email: email, password: password);
      if (result.status == 'success') {
        _account = result.data?.account;
        _accessToken = result.data?.accessToken;
        _refreshToken = result.data?.refreshToken;
        // Lưu token và user vào secure storage
        await _storage.write(key: 'accessToken', value: _accessToken);
        await _storage.write(key: 'refreshToken', value: _refreshToken);
      }
      return result;
    } catch (e) {
      return ResponseApi(
        status: 'error',
        message: 'Đăng nhập thất bại',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ResponseApi<Account>> updateAccount({
    required String accountId,
    required Map<String, dynamic> updatedData,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await AuthService.updateAccount(
          accountId: accountId, updatedData: updatedData);
      if (result.status == 'success') {
        _account = result.data;
      }
      return result;
    } catch (e) {
      return ResponseApi(status: 'error', message: 'Cập nhật thất bại');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromStorage() async {
    _accessToken = await _storage.read(key: 'accessToken');
    print('Token loaded from storage: $_accessToken');
    if (_accessToken != null) {
      bool isExpired = Jwt.isExpired(_accessToken!);
      if (!isExpired) {
        _account = await AuthService.getAccount();
      } else {
        _accessToken = null;
        await _storage.delete(key: 'accessToken');
      }
    } else {
      _account = null;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _account = null;
    _accessToken = null;
    _refreshToken = null;
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    notifyListeners();
  }
}
