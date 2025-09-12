class Task {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String location;
  final DateTime deadline;
  final String status;
  final String postedByUserId;
  final double? latitude;
  final double? longitude;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.location,
    required this.deadline,
    required this.status,
    required this.postedByUserId,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'location': location,
      'deadline': deadline.millisecondsSinceEpoch,
      'status': status,
      'postedByUserId': postedByUserId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      location: json['location'] ?? '',
      deadline: DateTime.fromMillisecondsSinceEpoch(json['deadline'] ?? 0),
      status: json['status'] ?? 'open',
      postedByUserId: json['postedByUserId'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}