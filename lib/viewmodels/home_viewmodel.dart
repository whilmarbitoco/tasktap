import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/task.dart';

class HomeViewModel extends ChangeNotifier {
  double? _userLatitude;
  double? _userLongitude;
  bool _isLoadingLocation = false;

  double? get userLatitude => _userLatitude;
  double? get userLongitude => _userLongitude;
  bool get isLoadingLocation => _isLoadingLocation;

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Grocery Shopping',
      description: 'Need someone to buy groceries from SM Tagum. List will be provided.',
      category: 'Home & Errands',
      price: 150,
      location: 'SM Tagum, Pioneer Avenue',
      deadline: DateTime.now().add(const Duration(hours: 3)),
      status: 'open',
      postedBy: 'Maria Santos',
      latitude: 7.4479,
      longitude: 125.8072,
    ),
    Task(
      id: '2',
      title: 'House Cleaning',
      description: 'Deep cleaning for 2-bedroom apartment. Supplies provided.',
      category: 'Home & Errands',
      price: 800,
      location: 'Apokon, Tagum City',
      deadline: DateTime.now().add(const Duration(days: 1)),
      status: 'open',
      postedBy: 'John Dela Cruz',
      latitude: 7.4500,
      longitude: 125.8100,
    ),
    Task(
      id: '3',
      title: 'Math Tutoring',
      description: 'Need help with Grade 10 Mathematics. 2 hours session.',
      category: 'Learning & Tutoring',
      price: 300,
      location: 'Magugpo East, Tagum City',
      deadline: DateTime.now().add(const Duration(days: 2)),
      status: 'open',
      postedBy: 'Ana Reyes',
      latitude: 7.4520,
      longitude: 125.8150,
    ),
    Task(
      id: '4',
      title: 'Appliance Repair',
      description: 'Fix washing machine that won\'t drain properly.',
      category: 'Repairs & Maintenance',
      price: 500,
      location: 'Mankilam, Tagum City',
      deadline: DateTime.now().add(const Duration(hours: 6)),
      status: 'open',
      postedBy: 'Carlos Mendoza',
      latitude: 7.4450,
      longitude: 125.8050,
    ),
    Task(
      id: '5',
      title: 'Pet Walking',
      description: 'Walk my Golden Retriever for 1 hour in the morning.',
      category: 'Care & Personal Assistance',
      price: 200,
      location: 'New Visayas, Tagum City',
      deadline: DateTime.now().add(const Duration(hours: 12)),
      status: 'open',
      postedBy: 'Lisa Garcia',
      latitude: 7.4480,
      longitude: 125.8120,
    ),
    Task(
      id: '6',
      title: 'Event Setup',
      description: 'Help setup birthday party decorations and tables.',
      category: 'Events & Miscellaneous',
      price: 400,
      location: 'Pagsabangan, Tagum City',
      deadline: DateTime.now().add(const Duration(days: 3)),
      status: 'open',
      postedBy: 'Miguel Torres',
      latitude: 7.4510,
      longitude: 125.8080,
    ),
  ];

  List<Task> get tasks => _tasks;

  List<Task> get suggestedTasks {
    // Simulate user's previous task history for suggestions
    return [
      _tasks[0], // Grocery Shopping
      _tasks[4], // Pet Walking
    ];
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