class Message {
  final String id;
  final String text;
  final String senderId;
  final String receiverId;
  final String taskId;
  final DateTime time;

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.taskId,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'taskId': taskId,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      taskId: json['taskId'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] ?? 0),
    );
  }

  bool isMe(String currentUserId) => senderId == currentUserId;
}