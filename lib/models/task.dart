class Task {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['is_completed'] is int
          ? json['is_completed'] == 1
          : json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'is_completed': isCompleted ? 1 : 0, // converteer bool naar int
    };
  }
}
