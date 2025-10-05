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
    return AuthResponse(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      account:
          json['account'] != null ? Account.fromJson(json['account']) : null,
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
