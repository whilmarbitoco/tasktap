class Conversation {
  final String id;
  final String taskId;
  final String otherUserId;
  final String otherUserName;
  final String taskTitle;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool hasUnreadMessages;

  Conversation({
    required this.id,
    required this.taskId,
    required this.otherUserId,
    required this.otherUserName,
    required this.taskTitle,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.hasUnreadMessages,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'taskTitle': taskTitle,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'hasUnreadMessages': hasUnreadMessages,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? '',
      taskId: json['taskId'] ?? '',
      otherUserId: json['otherUserId'] ?? '',
      otherUserName: json['otherUserName'] ?? '',
      taskTitle: json['taskTitle'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(
        json['lastMessageTime'] ?? 0,
      ),
      hasUnreadMessages: json['hasUnreadMessages'] ?? false,
    );
  }

  static Conversation fromFirebaseJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    final participants = Map<String, dynamic>.from(json['participants'] ?? {});
    final userNames = Map<String, dynamic>.from(json['userNames'] ?? {});

    final otherUserId = participants.keys.firstWhere(
      (userId) => userId != currentUserId,
      orElse: () => '',
    );

    return Conversation(
      id: json['id'] ?? '',
      taskId: json['taskId'] ?? '',
      otherUserId: otherUserId,
      otherUserName: userNames[otherUserId] ?? 'Unknown User',
      taskTitle: json['taskTitle'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(
        json['lastMessageTime'] ?? 0,
      ),
      hasUnreadMessages: false,
    );
  }
}
