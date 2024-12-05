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

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}
