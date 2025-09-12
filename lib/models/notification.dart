class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // 'task', 'system', 'message'
  final DateTime time;
  final bool isRead;
  final String? taskId;
  final String? fromUser;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    this.isRead = false,
    this.taskId,
    this.fromUser,
  });
}