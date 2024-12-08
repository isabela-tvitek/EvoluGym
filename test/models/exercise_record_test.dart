import 'package:flutter_test/flutter_test.dart';
import 'package:evolugym/models/exercise_record.dart';

void main() {
  group('ExerciseRecord', () {
    test('Deve desserializar corretamente de JSON', () {
      // JSON de exemplo
      final json = {
        "id": 1,
        "exerciseId": 101,
        "date": "2024-12-07",
        "series": 3,
        "weight": {"S1": 10.5, "S2": 12.0, "S3": 15.0},
        "time": null,
        "observation": "Bom treino"
      };

      // Converte JSON em um objeto ExerciseRecord
      final record = ExerciseRecord.fromJson(json);

      // Verifica os valores
      expect(record.id, 1);
      expect(record.exerciseId, 101);
      expect(record.date, "2024-12-07");
      expect(record.series, 3);
      expect(record.weight, {"S1": 10.5, "S2": 12.0, "S3": 15.0});
      expect(record.time, null);
      expect(record.observation, "Bom treino");
    });

    test('Deve serializar corretamente para JSON', () {
      // Objeto ExerciseRecord de exemplo
      final record = ExerciseRecord(
        id: 1,
        exerciseId: 101,
        date: "2024-12-07",
        series: 3,
        weight: {"S1": 10.5, "S2": 12.0, "S3": 15.0},
        time: null,
        observation: "Bom treino",
      );

      // Converte o objeto em JSON
      final json = record.toJson();

      // Verifica os valores no JSON
      expect(json['id'], 1);
      expect(json['exerciseId'], 101);
      expect(json['date'], "2024-12-07");
      expect(json['series'], 3);
      expect(json['weight'], {"S1": 10.5, "S2": 12.0, "S3": 15.0});
      expect(json['time'], null);
      expect(json['observation'], "Bom treino");
    });
  });
}
