import 'account.dart';

class NotificationModel {
  final String notificationId;
  final String receiverRole;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? updatedAt;
  Account? account;
  String? accountId;

  NotificationModel({
    required this.notificationId,
    required this.receiverRole,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.account,
    this.accountId,
  });

  /// Parse từ JSON sang object
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? json['_id'],
      receiverRole: json['receiverRole'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      account:
          json['account'] != null ? Account.fromJson(json['account']) : null,
      accountId: json['accountId'],
    );
  }
  // Viết hàm copyWith để dễ dàng sao chép và chỉnh sửa các thuộc tính
  NotificationModel copyWith({
    String? notificationId,
    String? receiverRole,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
    Account? account,
    String? accountId,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      receiverRole: receiverRole ?? this.receiverRole,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      account: account ?? this.account,
      accountId: accountId ?? this.accountId,
    );
  }

  /// Convert object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'receiverRole': receiverRole,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'accountId': accountId,
      'account': account?.toJson(),
    };
  }
}
