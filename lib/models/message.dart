class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isMe': isMe,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      isMe: json['isMe'] ?? false,
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] ?? 0),
    );
  }
}