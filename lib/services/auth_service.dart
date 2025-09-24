import 'api_client.dart';
import 'package:frontend_app/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '763500997258-mlhs837o79q1ftelhqqi7kp5op7garn9.apps.googleusercontent.com',
  );

  static Future<bool> googleAuth() async {
    try {
      // Nếu muốn lần nào cũng cho chọn tài khoản:
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("❌ Google sign-in bị hủy");
        return false;
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        print("❌ Không lấy được idToken từ Google");
        return false;
      }

      // Gửi token về backend
      final response = await ApiClient.dio.post(
        '/auth/google/mobile',
        data: {'idToken': idToken},
      );

      print("Google login response: ${response.data}");
      // Xử lý phản hồi từ backend
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final user = User.fromJson(data['user']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setString('user', jsonEncode(user.toJson()));

        return true;
      } else {
        print("❌ Google login thất bại với mã: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error Google login: $e");
      return false;
    }
  }

  /// 👉 Lấy thông tin user đã lưu
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      return User.fromJson(jsonDecode(userString));
    }
    return null;
  }

  /// 👉 Kiểm tra có login chưa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') != null;
  }

  /// 👉 Đăng xuất
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('user');
    await _googleSignIn.signOut();
    print("🚪 Logged out");
  }
}
