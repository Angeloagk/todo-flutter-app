class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
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
      'is_completed': isCompleted ? 1 : 0,
    };
  }
}
