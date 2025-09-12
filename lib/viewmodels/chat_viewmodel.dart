import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatViewModel extends ChangeNotifier {
  final String userName;
  final String taskTitle;
  final List<Message> _messages = [];

  ChatViewModel({required this.userName, required this.taskTitle}) {
    _initializeMessages();
  }

  List<Message> get messages => _messages;

  void _initializeMessages() {
    _messages.addAll([
      Message(
        id: '1',
        text: 'Hi! Is the ${taskTitle.toLowerCase()} task still available?',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        id: '2',
        text: 'Yes, it\'s still available! Are you interested?',
        isMe: true,
        time: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      Message(
        id: '3',
        text: 'Great! When would you like me to start?',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ]);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isMe: true,
      time: DateTime.now(),
    );
    
    _messages.add(message);
    notifyListeners();
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}