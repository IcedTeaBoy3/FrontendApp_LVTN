import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:frontend_app/configs/api_config.dart';

class WebSocketService {
  // 🔒 Singleton instance
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  IO.Socket? socket;
  String? _accountId;

  bool get isConnected => socket?.connected ?? false;

  void connect({required String accountId}) {
    // Nếu đã connect trước đó → không tạo lại
    if (isConnected && _accountId == accountId) {
      print('⚡ Socket already connected for $accountId');
      return;
    }

    _accountId = accountId;
    socket = IO.io(
      ApiConfig.backendUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print('✅ Connected to WebSocket server');
      socket!.emit('join_user', accountId);
      print('📌 Joined user room: $accountId');
    });

    socket!.onDisconnect((_) {
      print('❌ Disconnected from WebSocket server');
    });

    socket!.onConnectError((err) {
      print('⚠️ WebSocket connect error: $err');
    });
  }

  void on(String event, Function(dynamic) handler) {
    socket?.on(event, handler);
  }

  void emit(String event, dynamic data) {
    socket?.emit(event, data);
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
    _accountId = null;
    print('🔌 Socket disconnected');
  }
}
