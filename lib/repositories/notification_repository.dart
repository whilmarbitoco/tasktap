import 'package:firebase_database/firebase_database.dart';
import '../models/notification.dart';

abstract class NotificationRepository {
  Future<void> createNotification(AppNotification notification);
  Future<List<AppNotification>> getUserNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
}

class FirebaseNotificationRepository implements NotificationRepository {
  final DatabaseReference _notificationsRef = FirebaseDatabase.instance.ref().child('notifications');

  @override
  Future<void> createNotification(AppNotification notification) async {
    await _notificationsRef.child(notification.id).set(notification.toJson());
  }

  @override
  Future<List<AppNotification>> getUserNotifications(String userId) async {
    try {
      final snapshot = await _notificationsRef
          .orderByChild('userId')
          .equalTo(userId)
          .get();
      
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return data.values
              .map((notifData) => AppNotification.fromJson(Map<String, dynamic>.from(notifData)))
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
      }
    } catch (e) {
      // Handle error
    }
    return [];
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _notificationsRef.child(notificationId).update({'isRead': true});
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _notificationsRef.child(notificationId).remove();
  }
}