import 'package:flutter/material.dart';
import '../models/task.dart';

class ActiveTasksViewModel extends ChangeNotifier {
  String _selectedFilter = 'all';
  
  String get selectedFilter => _selectedFilter;
  
  final List<Task> _activeTasks = [
    Task(
      id: '1',
      title: 'Grocery Shopping',
      description: 'Buy groceries from SM Tagum. List provided.',
      category: 'Home & Errands',
      price: 150,
      location: 'SM Tagum, Pioneer Avenue',
      deadline: DateTime.now().add(const Duration(hours: 2)),
      status: 'in_progress',
      postedBy: 'Maria Santos',
      latitude: 7.4479,
      longitude: 125.8072,
    ),
    Task(
      id: '2',
      title: 'Pet Walking',
      description: 'Walk Golden Retriever for 1 hour.',
      category: 'Care & Personal Assistance',
      price: 200,
      location: 'New Visayas, Tagum City',
      deadline: DateTime.now().add(const Duration(hours: 8)),
      status: 'pending',
      postedBy: 'Lisa Garcia',
      latitude: 7.4480,
      longitude: 125.8120,
    ),
    Task(
      id: '3',
      title: 'House Cleaning',
      description: 'Deep cleaning for apartment.',
      category: 'Home & Errands',
      price: 800,
      location: 'Apokon, Tagum City',
      deadline: DateTime.now().add(const Duration(days: 1)),
      status: 'completed',
      postedBy: 'John Dela Cruz',
      latitude: 7.4500,
      longitude: 125.8100,
    ),
  ];

  List<Task> get activeTasks {
    if (_selectedFilter == 'all') return _activeTasks;
    return _activeTasks.where((task) => task.status == _selectedFilter).toList();
  }
  
  List<Task> get allTasks => _activeTasks;
  
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void startTask(String taskId) {
    final taskIndex = _activeTasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _activeTasks[taskIndex] = Task(
        id: _activeTasks[taskIndex].id,
        title: _activeTasks[taskIndex].title,
        description: _activeTasks[taskIndex].description,
        category: _activeTasks[taskIndex].category,
        price: _activeTasks[taskIndex].price,
        location: _activeTasks[taskIndex].location,
        deadline: _activeTasks[taskIndex].deadline,
        status: 'in_progress',
        postedBy: _activeTasks[taskIndex].postedBy,
        latitude: _activeTasks[taskIndex].latitude,
        longitude: _activeTasks[taskIndex].longitude,
      );
      notifyListeners();
    }
  }

  void completeTask(String taskId) {
    _activeTasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  String formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else {
      return '${difference.inMinutes} minutes';
    }
  }
}