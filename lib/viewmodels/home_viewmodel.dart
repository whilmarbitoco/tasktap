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
      category: 'Delivery',
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
      category: 'Cleaning',
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
      category: 'Tutoring',
      price: 300,
      location: 'Magugpo East, Tagum City',
      deadline: DateTime.now().add(const Duration(days: 2)),
      status: 'open',
      postedBy: 'Ana Reyes',
      latitude: 7.4520,
      longitude: 125.8150,
    ),
  ];

  List<Task> get tasks => _tasks;

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