// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseRecord _$ExerciseRecordFromJson(Map<String, dynamic> json) =>
    ExerciseRecord(
      id: (json['id'] as num?)?.toInt(),
      exerciseId: (json['exerciseId'] as num).toInt(),
      date: json['date'] as String,
      series: (json['series'] as num).toInt(),
      weight: (json['weight'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      time: (json['time'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      observation: json['observation'] as String?,
    );

Map<String, dynamic> _$ExerciseRecordToJson(ExerciseRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exerciseId': instance.exerciseId,
      'date': instance.date,
      'series': instance.series,
      'weight': instance.weight,
      'time': instance.time,
      'observation': instance.observation,
    };
