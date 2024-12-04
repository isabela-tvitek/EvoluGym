import 'package:evolugym/models/exercise_detail.dart';

class Exercise {
  final int? id; 
  final String name;
  final String type;

  Exercise({required this.id, required this.name, required this.type});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Desconhecido',
      type: json['type'] ?? 'Tipo não especificado',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }
}
