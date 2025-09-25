import 'user.dart';

class ResponseApi {
  final String status;
  final String message;
  final User? user;
  final String? accessToken;
  final String? refreshToken;

  ResponseApi({
    required this.status,
    required this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });
  factory ResponseApi.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ResponseApi(
      status: json['status'],
      message: json['message'],
      user: (data != null && data['user'] != null)
          ? User.fromJson(data['user'])
          : null,
      accessToken: data?['accessToken'],
      refreshToken: data?['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': {
        'user': user?.toJson(),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      },
    };
  }
}
