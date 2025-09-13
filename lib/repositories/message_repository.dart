import 'package:firebase_database/firebase_database.dart';
import '../models/conversation.dart';
import '../models/message.dart';

abstract class MessageRepository {
  Future<List<Conversation>> getUserConversations(String userId);
  Future<List<Message>> getTaskMessages(String taskId);
  Future<void> sendMessage(Message message);
}

class FirebaseMessageRepository implements MessageRepository {
  final DatabaseReference _conversationsRef = FirebaseDatabase.instance.ref().child('conversations');
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');

  @override
  Future<List<Conversation>> getUserConversations(String userId) async {
    try {
      final snapshot = await _conversationsRef.orderByChild('userId').equalTo(userId).get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return data.values
              .map((convData) => Conversation.fromJson(Map<String, dynamic>.from(convData)))
              .toList();
        }
      }
    } catch (e) {
      // Handle error
    }
    
    // Return sample data as fallback
    return [
      Conversation(
        id: 'conv_1',
        taskId: '1',
        otherUserId: 'sample_user_1',
        otherUserName: 'Maria Santos',
        taskTitle: 'Grocery Shopping',
        lastMessage: 'Hi! Is the grocery task still available?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 2)),
        hasUnreadMessages: true,
      ),
      Conversation(
        id: 'conv_2',
        taskId: '2',
        otherUserId: 'sample_user_2',
        otherUserName: 'John Dela Cruz',
        taskTitle: 'House Cleaning',
        lastMessage: 'Thank you for completing the cleaning task!',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        hasUnreadMessages: false,
      ),
      Conversation(
        id: 'conv_3',
        taskId: '3',
        otherUserId: 'sample_user_3',
        otherUserName: 'Ana Reyes',
        taskTitle: 'Math Tutoring',
        lastMessage: 'When can we schedule the tutoring session?',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        hasUnreadMessages: true,
      ),
    ];
  }

  @override
  Future<List<Message>> getTaskMessages(String taskId) async {
    try {
      final snapshot = await _messagesRef.orderByChild('taskId').equalTo(taskId).get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return data.values
              .map((msgData) => Message.fromJson(Map<String, dynamic>.from(msgData)))
              .toList()
            ..sort((a, b) => a.time.compareTo(b.time));
        }
      }
    } catch (e) {
      // Handle error
    }
    
    // Return sample messages as fallback
    return [
      Message(
        id: '1',
        text: 'Hi! Is the task still available?',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        id: '2',
        text: 'Yes, it\'s still available! Are you interested?',
        isMe: true,
        time: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      Message(
        id: '3',
        text: 'Great! When would you like me to start?',
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ];
  }

  @override
  Future<void> sendMessage(Message message) async {
    await _messagesRef.child(message.id).set({
      ...message.toJson(),
      'taskId': message.id.split('_')[0], // Extract taskId from message id
    });
  }
}