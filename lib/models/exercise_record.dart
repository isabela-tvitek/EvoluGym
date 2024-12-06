import 'package:json_annotation/json_annotation.dart';

part 'exercise_record.g.dart';

@JsonSerializable()
class ExerciseRecord {
  final int? id;
  final int exerciseId;
  final String date;
  final int series;
  final Map<String, double>? weight;
  final Map<String, int>? time;
  final String? observation;

  ExerciseRecord({
    required this.id,
    required this.exerciseId,
    required this.date,
    required this.series,
    this.weight,
    this.time,
    this.observation,
  });

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) =>
      _$ExerciseRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseRecordToJson(this);
}
