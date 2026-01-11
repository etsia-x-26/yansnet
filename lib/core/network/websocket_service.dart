import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketService {
  final String _url = 'http://yansnetapi.enlighteninnovation.com/ws';
  StompClient? _client;
  
  void Function(Map<String, dynamic>)? onMessageReceived;
  void Function(bool)? onConnectionStatusChanged;

  void connect(String username) {
    _client = StompClient(
      config: StompConfig(
        url: _url,
        onConnect: (frame) => _onConnect(frame, username),
        onWebSocketError: (error) => print('[WebSocket] Error: $error'),
        onStompError: (frame) => print('[WebSocket] STOMP Error: ${frame.body}'),
        onDisconnect: (frame) {
          print('[WebSocket] Disconnected');
          onConnectionStatusChanged?.call(false);
        },
      ),
    );
    _client?.activate();
  }

  void _onConnect(StompFrame frame, String username) {
    print('[WebSocket] Connected');
    onConnectionStatusChanged?.call(true);

    // Subscribe to public channel
    _client?.subscribe(
      destination: '/topic/public',
      callback: (frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          onMessageReceived?.call(data);
        }
      },
    );

    // Announce presence (Join)
    publish('/app/chat.addUser', {
      'sender': username,
      'type': 'JOIN',
    });
  }

  void publish(String destination, Map<String, dynamic> body) {
    _client?.send(
      destination: destination,
      body: jsonEncode(body),
    );
  }

  void sendMessage(String content, String sender) {
    publish('/app/chat.sendMessage', {
      'content': content,
      'sender': sender,
      'type': 'CHAT',
    });
  }

  void disconnect() {
    _client?.deactivate();
  }
}
