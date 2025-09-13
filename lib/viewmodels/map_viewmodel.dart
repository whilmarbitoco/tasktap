import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class MapViewModel extends ChangeNotifier {
  final MapController mapController = MapController();
  final TaskRepository _taskRepository;
  LatLng? _currentLocation;
  bool _isLoading = false;
  String _locationText = 'Getting location...';
  List<Task> _allTasks = [];
  List<Task> _nearbyTasks = [];
  static const double _radiusKm = 10.0;

  MapViewModel(this._taskRepository) {
    getCurrentLocation();
    _loadTasks();
  }

  LatLng? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String get locationText => _locationText;

  Future<void> _loadTasks() async {
    try {
      _allTasks = await _taskRepository.getAllTasks();
      _filterNearbyTasks();
    } catch (e) {
      _allTasks = [];
      _nearbyTasks = [];
    }
    notifyListeners();
  }

  void _filterNearbyTasks() {
    if (_currentLocation == null) {
      _nearbyTasks = _allTasks;
      return;
    }

    _nearbyTasks = _allTasks.where((task) {
      if (task.latitude == null || task.longitude == null) return false;
      
      final distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        task.latitude!,
        task.longitude!,
      );
      
      return distance <= _radiusKm * 1000;
    }).toList();
  }

  List<Task> get nearbyTasks => _nearbyTasks;

  List<Marker> get markers {
    final taskMarkers = _nearbyTasks
        .where((task) => task.latitude != null && task.longitude != null)
        .map((task) => Marker(
              point: LatLng(task.latitude!, task.longitude!),
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Icon(
                  _getCategoryIcon(task.category),
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ))
        .toList();

    if (_currentLocation != null) {
      taskMarkers.add(
        Marker(
          point: _currentLocation!,
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return taskMarkers;
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      _currentLocation = LatLng(position.latitude, position.longitude);

      // Get street address with barangay
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          String street = place.street ?? '';
          String barangay = place.subLocality ?? place.locality ?? '';

          if (street.isNotEmpty && barangay.isNotEmpty) {
            _locationText = '$street, $barangay';
          } else if (barangay.isNotEmpty) {
            _locationText = barangay;
          } else {
            _locationText = 'Tagum City';
          }
        } else {
          _locationText = 'Current Location';
        }
      } catch (e) {
        _locationText = 'Current Location';
      }

      mapController.move(_currentLocation!, 15.0);
      _filterNearbyTasks();
    } catch (e) {
      // Handle error silently
    }

    _isLoading = false;
    notifyListeners();
  }

  IconData _getCategoryIcon(String category) {
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

  void centerOnTagum() {
    mapController.move(const LatLng(7.4479, 125.8072), 14.0);
    _locationText = 'Tagum City, Davao del Norte';
    notifyListeners();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
