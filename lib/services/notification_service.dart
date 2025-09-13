import '../models/notification.dart';
import '../repositories/notification_repository.dart';

class NotificationService {
  final NotificationRepository _notificationRepository;

  NotificationService(this._notificationRepository);

  Future<void> sendTaskAcceptedNotification(String userId, String taskTitle) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: 'Task Accepted',
      message: 'Your task "$taskTitle" has been accepted!',
      type: 'task_accepted',
      createdAt: DateTime.now(),
    );
    
    await _notificationRepository.createNotification(notification);
  }

  Future<void> sendNewMessageNotification(String userId, String senderName, String taskTitle) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: 'New Message',
      message: '$senderName sent you a message about "$taskTitle"',
      type: 'new_message',
      createdAt: DateTime.now(),
    );
    
    await _notificationRepository.createNotification(notification);
  }

  Future<void> sendTaskCompletedNotification(String userId, String taskTitle) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: 'Task Completed',
      message: 'Task "$taskTitle" has been marked as completed!',
      type: 'task_completed',
      createdAt: DateTime.now(),
    );
    
    await _notificationRepository.createNotification(notification);
  }

  Future<List<AppNotification>> getUserNotifications(String userId) async {
    return await _notificationRepository.getUserNotifications(userId);
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationRepository.markAsRead(notificationId);
  }
}