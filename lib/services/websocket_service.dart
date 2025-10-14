import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:frontend_app/configs/api_config.dart';

class WebSocketService {
  // 🔒 Singleton instance
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  IO.Socket? socket;
  String? _accountId;
  String? _role;

  bool get isConnected => socket?.connected ?? false;

  /// Kết nối socket và tham gia vào phòng tương ứng (user/admin/doctor)
  void connect({required String accountId, required String role}) {
    if (isConnected && _accountId == accountId && _role == role) {
      print('⚡ Socket already connected for $role:$accountId');
      return;
    }

    _accountId = accountId;
    _role = role;

    socket = IO.io(
      ApiConfig.backendUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket!.connect();

    // Khi kết nối thành công
    socket!.onConnect((_) {
      print('✅ Connected to WebSocket server');
      // Gửi yêu cầu join phòng
      socket!.emit('join_room', {
        'role': role,
        'accountId': accountId,
      });
      print('📌 Joined rooms: $role, $accountId');
    });

    // Khi mất kết nối
    socket!.onDisconnect((_) {
      print('❌ Disconnected from WebSocket server');
    });

    // Khi kết nối lỗi
    socket!.onConnectError((err) {
      print('⚠️ WebSocket connect error: $err');
    });

    // Khi mất kết nối do timeout
    socket!.onError((err) {
      print('⚠️ WebSocket error: $err');
    });
  }

  /// Đăng ký sự kiện
  void on(String event, Function(dynamic) handler) {
    socket?.on(event, handler);
  }

  /// Gửi dữ liệu lên server
  void emit(String event, dynamic data) {
    socket?.emit(event, data);
  }

  /// Ngắt kết nối
  void disconnect() {
    socket?.disconnect();
    socket = null;
    _accountId = null;
    _role = null;
    print('🔌 Socket disconnected');
  }
}
