import 'package:firebase_database/firebase_database.dart';
import '../models/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);
  Future<User?> getUser(String userId);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String userId);
  Stream<User?> listenToUser(String userId);
  Future<List<User>> getAllUsers();
  Stream<List<User>> listenToAllUsers();
}

class FirebaseUserRepository implements UserRepository {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child(
    'users',
  );

  @override
  Future<void> createUser(User user) async {
    await _usersRef.child(user.id).set(user.toJson());
    print("User created with ID: ${user.id}");
  }

  @override
  Future<User?> getUser(String userId) async {
    final snapshot = await _usersRef.child(userId).get();
    if (snapshot.exists) {
      return User.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    await _usersRef.child(user.id).update(user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _usersRef.child(userId).remove();
  }

  @override
  Stream<User?> listenToUser(String userId) {
    return _usersRef.child(userId).onValue.map((event) {
      if (event.snapshot.exists) {
        return User.fromJson(
          Map<String, dynamic>.from(event.snapshot.value as Map),
        );
      }
      return null;
    });
  }

  @override
  Future<List<User>> getAllUsers() async {
    final snapshot = await _usersRef.get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> usersMap =
          snapshot.value as Map<dynamic, dynamic>;
      return usersMap.values
          .map((userData) => User.fromJson(Map<String, dynamic>.from(userData)))
          .toList();
    }
    return [];
  }

  @override
  Stream<List<User>> listenToAllUsers() {
    return _usersRef.onValue.map((event) {
      if (event.snapshot.exists) {
        final Map<dynamic, dynamic> usersMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        return usersMap.values
            .map(
              (userData) => User.fromJson(Map<String, dynamic>.from(userData)),
            )
            .toList();
      }
      return <User>[];
    });
  }
}
