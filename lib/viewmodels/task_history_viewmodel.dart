import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskHistoryViewModel extends ChangeNotifier {
  final List<Task> _completedTasks = [
    Task(
      id: 'h1',
      title: 'House Cleaning',
      description: 'Deep cleaning for 2-bedroom apartment',
      category: 'Home & Errands',
      price: 800,
      location: 'Apokon, Tagum City',
      deadline: DateTime.now().subtract(const Duration(days: 3)),
      status: 'completed',
      postedBy: 'John Dela Cruz',
      latitude: 7.4500,
      longitude: 125.8100,
    ),
    Task(
      id: 'h2',
      title: 'Math Tutoring',
      description: 'Grade 10 Mathematics tutoring session',
      category: 'Learning & Tutoring',
      price: 300,
      location: 'Magugpo East, Tagum City',
      deadline: DateTime.now().subtract(const Duration(days: 7)),
      status: 'completed',
      postedBy: 'Ana Reyes',
      latitude: 7.4520,
      longitude: 125.8150,
    ),
    Task(
      id: 'h3',
      title: 'Pet Walking',
      description: 'Walk Golden Retriever for 1 hour',
      category: 'Care & Personal Assistance',
      price: 200,
      location: 'New Visayas, Tagum City',
      deadline: DateTime.now().subtract(const Duration(days: 10)),
      status: 'completed',
      postedBy: 'Lisa Garcia',
      latitude: 7.4480,
      longitude: 125.8120,
    ),
    Task(
      id: 'h4',
      title: 'Event Setup',
      description: 'Birthday party decorations and setup',
      category: 'Events & Miscellaneous',
      price: 400,
      location: 'Pagsabangan, Tagum City',
      deadline: DateTime.now().subtract(const Duration(days: 14)),
      status: 'completed',
      postedBy: 'Miguel Torres',
      latitude: 7.4510,
      longitude: 125.8080,
    ),
  ];

  List<Task> get completedTasks => _completedTasks;

  double get totalEarnings => _completedTasks.fold(0, (sum, task) => sum + task.price);

  int get totalTasksCompleted => _completedTasks.length;

  Map<String, int> get tasksByCategory {
    final Map<String, int> categoryCount = {};
    for (final task in _completedTasks) {
      categoryCount[task.category] = (categoryCount[task.category] ?? 0) + 1;
    }
    return categoryCount;
  }

  String formatCompletedDate(DateTime deadline) {
    final now = DateTime.now();
    final difference = now.difference(deadline);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Recently';
    }
  }
}