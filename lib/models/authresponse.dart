import 'account.dart';

class AuthResponse {
  final Account? account;
  final String? accessToken;
  final String? refreshToken;

  AuthResponse({
    required this.account,
    required this.accessToken,
    required this.refreshToken,
  });
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'] as String?;
    final refreshToken = json['refreshToken'] as String? ?? '';
    final accountJson = json['account'] as Map<String, dynamic>?;
    if (accessToken == null || refreshToken == null || accountJson == null) {
      throw Exception(
          'AuthResponse.fromJson: thiếu accessToken hoặc refreshToken hoặc account');
    }
    return AuthResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      account: Account.fromJson(accountJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'account': account?.toJson(),
    };
  }
}
