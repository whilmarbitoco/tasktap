import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../repositories/message_repository.dart';

class MessagesViewModel extends ChangeNotifier {
  final MessageRepository _messageRepository;
  List<Conversation> _conversations = [];
  bool _isLoading = false;

  MessagesViewModel(this._messageRepository) {
    _loadConversations();
  }

  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;

  Future<void> _loadConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _conversations = await _messageRepository.getUserConversations('current_user');
    } catch (e) {
      _conversations = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshConversations() async {
    await _loadConversations();
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