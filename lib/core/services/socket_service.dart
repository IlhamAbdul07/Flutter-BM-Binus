import 'dart:convert';
import 'package:bm_binus/core/services/api_service.dart';
import 'package:bm_binus/core/services/storage_service.dart';
import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:flutter/widgets.dart';

const String baseUrlSocket = "wss://yusnar.my.id/socket-bm-binus";
SocketServiceManager socketServiceManager = SocketServiceManager();

class SocketServiceManager {
  static final SocketServiceManager _instance = SocketServiceManager._internal();
  factory SocketServiceManager() => _instance;
  SocketServiceManager._internal();

  final Map<String, SocketService> _activeSockets = {};
  final Map<String, bool> _connectCalled = {};

  SocketService getOrCreate({
    required String userId,
    required Function(dynamic) onDataReceive,
  }) {
    if (_activeSockets.containsKey(userId)) {
      final existing = _activeSockets[userId]!;
      existing.onDataReceive = onDataReceive;
      return existing;
    }

    final socket = SocketService(userId: userId, onDataReceive: onDataReceive);
    _activeSockets[userId] = socket;
    _connectCalled[userId] = false;
    return socket;
  }

  Future<SocketService> getOrCreateAndConnect({
    required String userId,
    required Function(dynamic) onDataReceive,
  }) async {
    final socket = getOrCreate(userId: userId, onDataReceive: onDataReceive);

    if (_connectCalled[userId] == true) {
      debugPrint("⚠️ Connect sudah dipanggil sebelumnya untuk userId=$userId, melewatkan connect ulang.");
      return socket;
    }

    try {
      _connectCalled[userId] = true;
      await socket.connect();
      debugPrint("✅ Connect berhasil untuk userId=$userId (manager)");
    } catch (e) {
      _connectCalled[userId] = false;
      debugPrint("❌ Gagal connect untuk userId=$userId: $e");
      rethrow;
    }

    return socket;
  }

  Future<void> disconnectAll() async {
    debugPrint("❌ Socket disconnected...");
    for (final socket in _activeSockets.values) {
      await socket.disconnect();
    }
    _activeSockets.clear();
  }
}

class SocketService {
  late centrifuge.Client _client;
  centrifuge.Subscription? _subscription;
  late String userId;
  late Function(dynamic data) onDataReceive;

  SocketService({required this.userId, required this.onDataReceive});

  Future<void> connect() async {
    final token = StorageService.getToken();

    if (token == null || userId.isEmpty) {
      debugPrint("❌ Token null atau userId kosong. Gagal konek.");
      return;
    }

    debugPrint("🚀 Menghubungkan ke Centrifuge: userId=$userId");

    _client = centrifuge.createClient(
      '$baseUrlSocket/websocket',
      centrifuge.ClientConfig(name: 'dart', token: token),
    );

    _client.connected.listen((event) {
      debugPrint("✅ Socket connected. Subscribing channel...");
      _subscribeToChannel();
    });

    _client.disconnected.listen((event) {
      debugPrint("⚠️ Socket disconnected (code: ${event.code}, reason: ${event.reason})");
      socketServiceManager._connectCalled[userId] = false;
      switch (event.code) {
        case 109:
          _handleTokenExpired(token);
          break;
        case 3500:
          _handleTokenInvalid();
          break;
        case 3000:
          break;
        default:
          _reconnect();
      }
    });

    _client.error.listen((event) {
      debugPrint("💥 Socket error: ${event.error}");
    });

    await _client.connect();
  }

  void _subscribeToChannel() {
    final channel = userId;
    _subscription = _client.newSubscription(channel);

    _subscription?.publication.listen((event) {
      final Map<String, dynamic> message = json.decode(utf8.decode(event.data));
      onDataReceive(message);
    });

    _subscription?.subscribe();
  }

  Future<Map<String, dynamic>?> sendRpc(
    String method,
    Map<String, dynamic> data,
  ) async {
    try {
      if (_client.state != centrifuge.State.connected) {
        debugPrint('Cannot send RPC: Client is not connected.');
        await _reconnect();
        if (_client.state != centrifuge.State.connected) {
          return null;
        }
      }

      final encodedData = jsonEncode(data);

      final response = await _client.rpc(method, utf8.encode(encodedData));

      final decodedResponse = json.decode(utf8.decode(response.data));

      return decodedResponse as Map<String, dynamic>;
    } catch (e) {
      debugPrint('RPC Error: $e');
      return null;
    }
  }

  Future<void> disconnect() async {
    await _client.disconnect();
  }

  Future<void> _handleTokenExpired(String? token) async {
    final newToken = await ApiService.refreshTokenForWebSocket(token);
    if (newToken != null) {
      await _client.disconnect();
      await connect();
    } else {
      debugPrint('❌ Failed to refresh token.');
    }
  }

  Future<void> _handleTokenInvalid() async {
    await _client.disconnect();
    await connect();
  }

  Future<void> _reconnect() async {
    await _client.disconnect();
    await connect();
  }
}
