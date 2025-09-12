class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImageUrl;
  final bool isVerified;
  final double rating;
  final int tasksCompleted;
  final double earnings;
  final DateTime createdAt;
  final DateTime? lastActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImageUrl,
    this.isVerified = false,
    this.rating = 0.0,
    this.tasksCompleted = 0,
    this.earnings = 0.0,
    required this.createdAt,
    this.lastActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'isVerified': isVerified,
      'rating': rating,
      'tasksCompleted': tasksCompleted,
      'earnings': earnings,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastActive': lastActive?.millisecondsSinceEpoch,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
      isVerified: json['isVerified'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      tasksCompleted: json['tasksCompleted'] ?? 0,
      earnings: (json['earnings'] ?? 0.0).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      lastActive: json['lastActive'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['lastActive'])
          : null,
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    bool? isVerified,
    double? rating,
    int? tasksCompleted,
    double? earnings,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      earnings: earnings ?? this.earnings,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}