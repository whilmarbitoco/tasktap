import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../repositories/user_repository.dart';
import '../services/migration_service.dart';

class HomeViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final UserRepository _userRepository;
  late final MigrationService _migrationService;

  double? _userLatitude;
  double? _userLongitude;
  bool _isLoadingLocation = false;
  List<Task> _tasks = [];
  bool _isLoadingTasks = false;

  HomeViewModel(this._taskRepository, this._userRepository) {
    _migrationService = MigrationService(_userRepository, _taskRepository);
    _loadTasks();
  }

  double? get userLatitude => _userLatitude;
  double? get userLongitude => _userLongitude;
  bool get isLoadingLocation => _isLoadingLocation;
  bool get isLoadingTasks => _isLoadingTasks;

  List<Task> get tasks => _tasks;

  Future<void> _loadTasks() async {
    _isLoadingTasks = true;
    notifyListeners();

    try {
      _tasks = await _taskRepository.getAllTasks();
    } catch (e) {
      print(e);
      _tasks = [];
    }

    _isLoadingTasks = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    try {
      await _taskRepository.createTask(task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> refreshTasks() async {
    await _loadTasks();
  }

  List<Task> get suggestedTasks {
    if (_tasks.isEmpty) return [];

    final suggestions = <Task>[];
    if (_tasks.length > 0) suggestions.add(_tasks[0]);
    if (_tasks.length > 4) suggestions.add(_tasks[4]);

    return suggestions;
  }

  Map<String, List<Task>> get tasksByCategory {
    final Map<String, List<Task>> grouped = {};
    for (final task in _tasks) {
      if (!grouped.containsKey(task.category)) {
        grouped[task.category] = [];
      }
      grouped[task.category]!.add(task);
    }
    return grouped;
  }

  static const List<String> categories = [
    'Home & Errands',
    'Repairs & Maintenance',
    'Learning & Tutoring',
    'Care & Personal Assistance',
    'Events & Miscellaneous',
  ];

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Home & Errands':
        return Icons.home;
      case 'Repairs & Maintenance':
        return Icons.build;
      case 'Learning & Tutoring':
        return Icons.school;
      case 'Care & Personal Assistance':
        return Icons.favorite;
      case 'Events & Miscellaneous':
        return Icons.celebration;
      default:
        return Icons.work;
    }
  }

  Future<void> getUserLocation() async {
    _isLoadingLocation = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _isLoadingLocation = false;
          notifyListeners();
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      _userLatitude = position.latitude;
      _userLongitude = position.longitude;
    } catch (e) {
      // Handle error silently
    }

    _isLoadingLocation = false;
    notifyListeners();
  }
}
