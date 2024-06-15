class Task {
  late String id;
  late String title;
  late bool completed;

  Task({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    completed = json['completed'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
