import 'package:firebase_database/firebase_database.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../repositories/task_repository.dart';
import '../repositories/user_repository.dart';

abstract class MessageRepository {
  Future<List<Conversation>> getUserConversations(String userId);
  Future<List<Message>> getTaskMessages(String taskId);
  Future<List<Message>> getChatMessages(String userId1, String userId2);
  Future<void> sendMessage(Message message);
}

class FirebaseMessageRepository implements MessageRepository {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child(
    'messages',
  );
  final DatabaseReference _conversationsRef = FirebaseDatabase.instance
      .ref()
      .child('conversations');
  final TaskRepository _taskRepository;
  final UserRepository _userRepository;

  FirebaseMessageRepository(this._taskRepository, this._userRepository);

  @override
  Future<List<Conversation>> getUserConversations(String userId) async {
    try {
      print('Querying conversations for userId: $userId');
      
      // Get all conversations and filter by userId prefix
      final snapshot = await _conversationsRef.get();
      
      print('Snapshot exists: ${snapshot.exists}');
      if (!snapshot.exists || snapshot.value == null) {
        print('No conversations found');
        return [];
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      print('Found ${data.length} total conversation records');
      final conversations = <Conversation>[];

      // Filter conversations that belong to the current user
      for (final entry in data.entries) {
        final conversationId = entry.key;
        final convData = Map<String, dynamic>.from(entry.value);
        
        // Check if this conversation belongs to the current user
        if (conversationId.startsWith('${userId}_')) {
          final conversation = Conversation.fromJson(convData);
          conversations.add(conversation);
          print(
            'Added conversation: ${conversation.otherUserName} - ${conversation.taskTitle}',
          );
        }
      }

      print('Filtered to ${conversations.length} conversations for user');
      conversations.sort(
        (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
      );
      return conversations;
    } catch (e) {
      print("Error fetching conversations: $e");
      return [];
    }
  }

  @override
  Future<List<Message>> getTaskMessages(String taskId) async {
    try {
      // Get all conversations and find the one for this task
      final conversationsSnapshot = await _conversationsRef.get();
      if (!conversationsSnapshot.exists) return [];
      
      final conversationsData = Map<String, dynamic>.from(conversationsSnapshot.value as Map);
      String? chatId;
      
      // Find the chat ID for this task
      for (final entry in conversationsData.entries) {
        final convData = Map<String, dynamic>.from(entry.value);
        if (convData['taskId'] == taskId) {
          // Extract user IDs from conversation to build chat ID
          final userId = convData['userId'];
          final otherUserId = convData['otherUserId'];
          chatId = _generateChatId(userId, otherUserId);
          break;
        }
      }
      
      if (chatId == null) return [];
      
      final snapshot = await _messagesRef.child(chatId).get();
      if (snapshot.exists && snapshot.value is Map) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final messages = data.values
            .map((msgData) => Message.fromJson(Map<String, dynamic>.from(msgData)))
            .toList();
        
        messages.sort((a, b) => a.time.compareTo(b.time));
        return messages;
      }
      return [];
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    }
  }

  @override
  Future<void> sendMessage(Message message) async {
    try {
      final chatId = _generateChatId(message.senderId, message.receiverId);
      await _messagesRef.child(chatId).child(message.id).set(message.toJson());
      await _createOrUpdateConversation(message);
    } catch (e) {
      print("Error sending message: $e");
      rethrow;
    }
  }
  
  @override
  Future<List<Message>> getChatMessages(String userId1, String userId2) async {
    try {
      final chatId = _generateChatId(userId1, userId2);
      final snapshot = await _messagesRef.child(chatId).get();
      
      if (snapshot.exists && snapshot.value is Map) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final messages = data.values
            .map((msgData) => Message.fromJson(Map<String, dynamic>.from(msgData)))
            .toList();
        
        messages.sort((a, b) => a.time.compareTo(b.time));
        return messages;
      }
      return [];
    } catch (e) {
      print("Error fetching chat messages: $e");
      return [];
    }
  }
  
  String _generateChatId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  Future<void> _createOrUpdateConversation(Message message) async {
    try {
      final task = await _taskRepository.getTask(message.taskId);
      if (task == null) return;

      final senderUser = await _userRepository.getUser(message.senderId);
      final receiverUser = await _userRepository.getUser(message.receiverId);

      // Create conversation for sender
      final senderConversationId = '${message.senderId}_${message.taskId}';
      final senderConversationData = {
        'id': senderConversationId,
        'taskId': message.taskId,
        'userId': message.senderId,
        'otherUserId': message.receiverId,
        'otherUserName': receiverUser?.name ?? 'Unknown User',
        'taskTitle': task.title,
        'lastMessage': message.text,
        'lastMessageTime': message.time.millisecondsSinceEpoch,
        'hasUnreadMessages': false,
      };

      // Create conversation for receiver
      final receiverConversationId = '${message.receiverId}_${message.taskId}';
      final receiverConversationData = {
        'id': receiverConversationId,
        'taskId': message.taskId,
        'userId': message.receiverId,
        'otherUserId': message.senderId,
        'otherUserName': senderUser?.name ?? 'Unknown User',
        'taskTitle': task.title,
        'lastMessage': message.text,
        'lastMessageTime': message.time.millisecondsSinceEpoch,
        'hasUnreadMessages': true,
      };

      await _conversationsRef
          .child(senderConversationId)
          .set(senderConversationData);
      await _conversationsRef
          .child(receiverConversationId)
          .set(receiverConversationData);
    } catch (e) {
      print("Error creating/updating conversation: $e");
    }
  }
}
