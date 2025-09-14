import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/message.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../repositories/message_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/task_repository.dart';
import '../services/notification_service.dart';

class ChatViewModel extends ChangeNotifier {
  final String taskId;
  final MessageRepository _messageRepository;
  final UserRepository _userRepository;
  final TaskRepository _taskRepository;
  final NotificationService _notificationService;
  final List<Message> _messages = [];
  String userName = 'Task Owner';
  String taskTitle = 'Task Discussion';
  bool _isLoading = false;
  User? _otherUser;
  Task? _task;
  String? _currentUserId;

  ChatViewModel({
    required this.taskId,
    required MessageRepository messageRepository,
    required UserRepository userRepository,
    required TaskRepository taskRepository,
    required NotificationService notificationService,
  }) : _messageRepository = messageRepository,
       _userRepository = userRepository,
       _taskRepository = taskRepository,
       _notificationService = notificationService {
    _currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
    _loadChatData();
  }

  bool get isLoading => _isLoading;
  User? get otherUser => _otherUser;
  Task? get task => _task;
  String? get currentUserId => _currentUserId;

  List<Message> get messages => _messages;

  Future<void> _loadChatData() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('Loading chat data for taskId: $taskId');

      // Load task information
      _task = await _taskRepository.getTask(taskId);
      if (_task != null) {
        taskTitle = _task!.title;
        print('Task loaded: ${_task!.title}');

        // Determine other user (if current user is task owner, other user is the one messaging)
        // For now, assume other user is the task owner
        final otherUserId = _task!.postedByUserId != _currentUserId
            ? _task!.postedByUserId
            : _currentUserId; // This needs to be determined from conversation

        _otherUser = await _userRepository.getUser(otherUserId!);
        if (_otherUser != null) {
          userName = _otherUser!.name;
          print('Other user loaded: ${_otherUser!.name}');
        }
      }

      // Load messages using user IDs
      if (_otherUser != null && _currentUserId != null) {
        print('Loading messages between $_currentUserId and ${_otherUser!.id}');
        final messages = await _messageRepository.getChatMessages(_currentUserId!, _otherUser!.id);
        _messages.clear();
        _messages.addAll(messages);
        print('Loaded ${messages.length} messages');
      }
    } catch (e) {
      print('Error loading chat data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _currentUserId == null || _otherUser == null)
      return;

    final message = Message(
      id: '${taskId}_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      senderId: _currentUserId!,
      receiverId: _otherUser!.id,
      taskId: taskId,
      time: DateTime.now(),
    );

    _messages.add(message);
    notifyListeners();

    try {
      await _messageRepository.sendMessage(message);
      print('Message sent successfully');

      // Send notification to other user
      if (_otherUser != null && _task != null) {
        await _notificationService.sendNewMessageNotification(
          _otherUser!.id,
          'You', // Current user name
          _task!.title,
        );
      }
    } catch (e) {
      print('Error sending message: $e');
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
