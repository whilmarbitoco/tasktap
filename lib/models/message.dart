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
}