// lib/screens/community_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:farmiq_app/services/chat_service.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final ChatService _chatService = ChatService();
  final _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String _userName = 'Krishna'; // In a real app, get this from user profile

  @override
  void initState() {
    super.initState();
    _chatService.connect();
    _chatService.onMessageReceived((data) {
      if (mounted) {
        setState(() {
          _messages.add({'user': data['user'], 'message': data['message']});
        });
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;
      setState(() {
        _messages.add({'user': _userName, 'message': message});
      });
      _chatService.sendMessage(message, _userName);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Chat'),
        backgroundColor: const Color(0xFF3b5d46),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['user'] == _userName;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF3b5d46) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg['user']!, style: TextStyle(fontWeight: FontWeight.bold, color: isMe ? Colors.white70 : Colors.black54)),
                        Text(msg['message']!, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF3b5d46)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}