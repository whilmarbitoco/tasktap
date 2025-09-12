import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final double? userLatitude;
  final double? userLongitude;

  const TaskCard({
    super.key,
    required this.task,
    this.userLatitude,
    this.userLongitude,
  });

  String _calculateDistance() {
    if (userLatitude == null || userLongitude == null || 
        task.latitude == null || task.longitude == null) {
      return '';
    }
    
    double distanceInMeters = Geolocator.distanceBetween(
      userLatitude!,
      userLongitude!,
      task.latitude!,
      task.longitude!,
    );
    
    double distanceInKm = distanceInMeters / 1000;
    if (distanceInKm < 1) {
      return '${distanceInMeters.round()}m away';
    } else {
      return '${distanceInKm.toStringAsFixed(1)}km away';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.location,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      if (_calculateDistance().isNotEmpty)
                        Text(
                          _calculateDistance(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  '₱${task.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}