import 'api_client.dart';
import 'package:frontend_app/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '763500997258-mlhs837o79q1ftelhqqi7kp5op7garn9.apps.googleusercontent.com',
  );

  static Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      // Nếu muốn lần nào cũng cho chọn tài khoản:
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("❌ Google sign-in bị hủy");
        return null;
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        print("❌ Không lấy được idToken từ Google");
        return null;
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
        return {
          'user': user,
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        };
      } else {
        print("❌ Google login thất bại với mã: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error Google login: $e");
      return null;
    }
  }

  /// 👉 Lấy thông tin user đã lưu
  static Future<User?> getUser() async {
    try {
      final response = await ApiClient.dio.get(
        '/user/profile',
      );
      print("Get user response: ${response.data}");
      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }
}
