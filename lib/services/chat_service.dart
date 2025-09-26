// lib/services/chat_service.dart
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatService {
  late io.Socket socket;

  void connect() {
    socket = io.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  void sendMessage(String message, String user) {
    socket.emit('chat message', {'message': message, 'user': user});
  }

  void onMessageReceived(Function(dynamic) handler) {
    socket.on('chat message', handler);
  }
}