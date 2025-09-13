import 'package:flutter/material.dart';
import '../models/message.dart';
import '../repositories/message_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final String taskId;
  final MessageRepository _messageRepository;
  final List<Message> _messages = [];
  String userName = 'Task Owner';
  String taskTitle = 'Task Discussion';
  bool _isLoading = false;

  ChatViewModel({required this.taskId, required MessageRepository messageRepository}) 
      : _messageRepository = messageRepository {
    _loadMessages();
  }

  bool get isLoading => _isLoading;

  List<Message> get messages => _messages;

  Future<void> _loadMessages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final messages = await _messageRepository.getTaskMessages(taskId);
      _messages.clear();
      _messages.addAll(messages);
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isMe: true,
      time: DateTime.now(),
    );
    
    _messages.add(message);
    notifyListeners();

    try {
      await _messageRepository.sendMessage(message);
    } catch (e) {
      // Handle error
    }
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