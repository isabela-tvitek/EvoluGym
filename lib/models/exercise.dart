class Exercise {
  final int? id;
  final String name;
  final String type;

  Exercise({this.id, required this.name, required this.type});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      type: map['type'],
    );
  }
}
