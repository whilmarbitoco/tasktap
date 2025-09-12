import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationsViewModel extends ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Task Accepted',
      message: 'Maria Santos accepted your grocery shopping task',
      type: 'task',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      fromUser: 'Maria Santos',
      taskId: '1',
    ),
    AppNotification(
      id: '2',
      title: 'New Message',
      message: 'You have a new message from John Dela Cruz',
      type: 'message',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      fromUser: 'John Dela Cruz',
    ),
    AppNotification(
      id: '3',
      title: 'Task Completed',
      message: 'Your house cleaning task has been completed',
      type: 'task',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      taskId: '2',
    ),
    AppNotification(
      id: '4',
      title: 'Payment Received',
      message: 'You received ₱300 for math tutoring task',
      type: 'system',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: '5',
      title: 'Task Reminder',
      message: 'Your pet walking task starts in 1 hour',
      type: 'system',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  List<AppNotification> get notifications => _notifications;
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = AppNotification(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        type: _notifications[index].type,
        time: _notifications[index].time,
        isRead: true,
        taskId: _notifications[index].taskId,
        fromUser: _notifications[index].fromUser,
      );
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = AppNotification(
          id: _notifications[i].id,
          title: _notifications[i].title,
          message: _notifications[i].message,
          type: _notifications[i].type,
          time: _notifications[i].time,
          isRead: true,
          taskId: _notifications[i].taskId,
          fromUser: _notifications[i].fromUser,
        );
      }
    }
    notifyListeners();
  }

  IconData getNotificationIcon(String type) {
    switch (type) {
      case 'task':
        return Icons.assignment;
      case 'message':
        return Icons.message;
      case 'system':
        return Icons.notifications;
      default:
        return Icons.info;
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