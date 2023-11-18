import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_messenger/singleton/user_data.dart';

class ConnectionService {
  static ConnectionService? _instance;
  WebSocketChannel? channel;

  final _streamController = StreamController<dynamic>.broadcast();

  // Private constructor to prevent direct instantiation
  ConnectionService._();

  // Factory constructor to create or return the existing instance
  factory ConnectionService() {
    _instance ??= ConnectionService._();
    return _instance!;
  }

  Future<void> connect(String token) async {
    channel = WebSocketChannel.connect(
      Uri.parse('${dotenv.env['WS_URL']}?token=$token'),
    );

    channel?.stream.listen(
      (data) {
        _streamController.add(data);
      },
      onDone: () {
        print("WebSocket closed");
      },
      onError: (error) {
        print("WebSocket error: $error");
      }
    );
  }

  Stream<dynamic> get stream => _streamController.stream;

  void sendMessage(String message, String friendId) {
    if (channel != null) {
      try {
        String msg = "/msg ${userData.id} $friendId $message";
        channel!.sink.add(msg);
      } catch (e) {
        print('Error sending message: $e');
        // Handle the error if the message couldn't be sent.
      }
    } else {
      print('WebSocket is not connected.');
      // Handle the case where the WebSocket is not connected.
    }
  }

  void close() {
    channel?.sink.close();
    _streamController.close();
    channel = null;
  }
}