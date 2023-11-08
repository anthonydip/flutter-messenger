import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConnectionService {
  static ConnectionService? _instance;
  WebSocketChannel? channel;

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

    // Listen to errors on the WebSocket
    channel?.sink.done.then((_) {
      print('WebSocket closed');
    }).catchError((error) {
      print('WebSocket error: $error');
    });
  }

  void sendMessage(String message) {
    if (channel != null) {
      try {
        channel!.sink.add(message);
        print('Message sent: $message');
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
    channel = null;
  }
}