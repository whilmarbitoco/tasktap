class Task {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String location;
  final DateTime deadline;
  final String status;
  final String postedBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.location,
    required this.deadline,
    required this.status,
    required this.postedBy,
  });
}