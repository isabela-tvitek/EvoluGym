class Exercise {
  final int? id;
  final String name;
  final String type;
  final bool completed;

  Exercise({
    this.id,
    required this.name,
    required this.type,
    this.completed = false,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'completed': completed,
    };
  }
}
