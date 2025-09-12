import 'package:firebase_database/firebase_database.dart';
import '../models/task.dart';

abstract class TaskRepository {
  Future<void> createTask(Task task);
  Future<Task?> getTask(String taskId);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Stream<Task?> listenToTask(String taskId);
  Future<List<Task>> getAllTasks();
  Stream<List<Task>> listenToAllTasks();
}

class FirebaseTaskRepository implements TaskRepository {
  final DatabaseReference _tasksRef = FirebaseDatabase.instance.ref().child(
    'tasks',
  );

  @override
  Future<void> createTask(Task task) async {
    await _tasksRef.child(task.id).set(task.toJson());
  }

  @override
  Future<Task?> getTask(String taskId) async {
    final snapshot = await _tasksRef.child(taskId).get();
    if (snapshot.exists && snapshot.value != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return Task.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  @override
  Future<void> updateTask(Task task) async {
    await _tasksRef.child(task.id).update(task.toJson());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _tasksRef.child(taskId).remove();
  }

  @override
  Stream<Task?> listenToTask(String taskId) {
    return _tasksRef.child(taskId).onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        return Task.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    });
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final snapshot = await _tasksRef.get();
    if (snapshot.exists && snapshot.value != null) {
      return _parseTasks(snapshot.value);
    }
    return [];
  }

  @override
  Stream<List<Task>> listenToAllTasks() {
    return _tasksRef.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return _parseTasks(event.snapshot.value);
      }
      return <Task>[];
    });
  }

  /// Helper method to parse tasks safely
  List<Task> _parseTasks(dynamic data) {
    if (data is Map) {
      return data.values
          .where((taskData) => taskData != null)
          .map((taskData) => Task.fromJson(Map<String, dynamic>.from(taskData)))
          .toList();
    } else if (data is List) {
      return data
          .where((taskData) => taskData != null)
          .map((taskData) => Task.fromJson(Map<String, dynamic>.from(taskData)))
          .toList();
    }
    return [];
  }
}
