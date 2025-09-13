import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/conversation.dart';
import '../repositories/message_repository.dart';

class MessagesViewModel extends ChangeNotifier {
  final MessageRepository _messageRepository;
  List<Conversation> _conversations = [];
  List<Conversation> _filteredConversations = [];
  bool _isLoading = false;
  String _searchQuery = '';

  MessagesViewModel(this._messageRepository) {
    print('MessagesViewModel initialized');
    // Delay fetching until after widget binding is ready
    Future.microtask(() => _loadConversations());
  }

  List<Conversation> get conversations =>
      _searchQuery.isEmpty ? _conversations : _filteredConversations;

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> _loadConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      print('Loading conversations for user: $currentUserId');

      if (currentUserId != null) {
        final results = await _messageRepository.getUserConversations(
          currentUserId,
        );
        _conversations = results;
        print('✅ Loaded ${_conversations.length} conversations');
      } else {
        print('⚠️ No current user found');
        _conversations = [];
      }
    } catch (e, stack) {
      print('❌ Error loading conversations: $e');
      print(stack);
      _conversations = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshConversations() async {
    await _loadConversations();
  }

  void searchConversations(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredConversations = [];
    } else {
      _filteredConversations = _conversations.where((conversation) {
        return conversation.otherUserName.toLowerCase().contains(
              _searchQuery,
            ) ||
            conversation.taskTitle.toLowerCase().contains(_searchQuery) ||
            conversation.lastMessage.toLowerCase().contains(_searchQuery);
      }).toList();
    }
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
