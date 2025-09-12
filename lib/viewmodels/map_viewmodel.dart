import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/task.dart';

class MapViewModel extends ChangeNotifier {
  final MapController mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoading = false;
  String _locationText = 'Tagum City, Davao del Norte';

  LatLng? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String get locationText => _locationText;

  final List<Task> _nearbyTasks = [
    Task(
      id: '1',
      title: 'Grocery Shopping',
      description: 'Need someone to buy groceries from SM Tagum',
      category: 'Delivery',
      price: 150,
      location: 'SM Tagum',
      deadline: DateTime.now().add(const Duration(hours: 3)),
      status: 'open',
      postedBy: 'Maria Santos',
    ),
    Task(
      id: '2',
      title: 'House Cleaning',
      description: 'Deep cleaning for 2-bedroom apartment',
      category: 'Cleaning',
      price: 800,
      location: 'Apokon, Tagum',
      deadline: DateTime.now().add(const Duration(days: 1)),
      status: 'open',
      postedBy: 'John Dela Cruz',
    ),
  ];

  List<Task> get nearbyTasks => _nearbyTasks;

  List<Marker> get markers {
    final taskMarkers = [
      Marker(
        point: const LatLng(7.4479, 125.8072),
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
        ),
      ),
      Marker(
        point: const LatLng(7.4500, 125.8100),
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: const Icon(Icons.cleaning_services, color: Colors.white, size: 20),
        ),
      ),
    ];

    if (_currentLocation != null) {
      taskMarkers.add(
        Marker(
          point: _currentLocation!,
          width: 50,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
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
      
      // Get street address
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          _locationText = '${place.street}, ${place.locality}';
        } else {
          _locationText = 'Current Location';
        }
      } catch (e) {
        _locationText = 'Current Location';
      }
      
      mapController.move(_currentLocation!, 15.0);
    } catch (e) {
      // Handle error silently
    }

    _isLoading = false;
    notifyListeners();
  }

  void centerOnTagum() {
    mapController.move(const LatLng(7.4479, 125.8072), 14.0);
    _locationText = 'Tagum City, Davao del Norte';
    notifyListeners();
  }
}