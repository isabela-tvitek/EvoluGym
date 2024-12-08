import 'package:json_annotation/json_annotation.dart';
import 'exercise_record.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise {
  final int? id;
  final String name;
  final String type;
  final List<ExerciseRecord> records;

  Exercise({
    required this.id,
    required this.name,
    required this.type,
    required this.records,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'records': records.map((record) => record.toJson()).toList(),
      };
}
