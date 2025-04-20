class Task {
  final String id;
  final String userId;
  final String title;
  final String status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.status,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      status: json['status'] as String? ?? 'pending', // Default to 'pending'
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'status': status,
      'created_at': createdAt.toUtc().toIso8601String().replaceFirst(
        '.000Z',
        'Z',
      ),
    };
  }
}
