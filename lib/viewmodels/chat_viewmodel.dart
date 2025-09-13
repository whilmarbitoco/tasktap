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
      // Load task information
      _task = await _taskRepository.getTask(taskId);
      if (_task != null) {
        taskTitle = _task!.title;
        // Load other user information
        _otherUser = await _userRepository.getUser(_task!.postedByUserId);
        if (_otherUser != null) {
          userName = _otherUser!.name;
        }
      }

      // Load messages
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
    if (text.trim().isEmpty || _currentUserId == null) return;

    final message = Message(
      id: '${taskId}_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      senderId: _currentUserId!,
      receiverId: _task?.postedByUserId ?? '',
      taskId: taskId,
      time: DateTime.now(),
    );

    _messages.add(message);
    notifyListeners();

    try {
      await _messageRepository.sendMessage(message);

      // Send notification to other user
      if (_otherUser != null && _task != null) {
        await _notificationService.sendNewMessageNotification(
          _otherUser!.id,
          'You', // Current user name
          _task!.title,
        );
      }
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
