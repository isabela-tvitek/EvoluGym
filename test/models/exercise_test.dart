import 'package:flutter_test/flutter_test.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/models/exercise_record.dart';

void main() {
  group('Exercise', () {
    test('Deve serializar corretamente para JSON', () {
      // Objeto Exercise de exemplo
      final exercise = Exercise(
        id: 1,
        name: "Supino",
        type: "musculação",
        records: [
          ExerciseRecord(
            id: 1,
            exerciseId: 101,
            date: "2024-12-07",
            series: 3,
            weight: {"S1": 10.5, "S2": 12.0, "S3": 15.0},
            time: null,
            observation: "Bom treino",
          ),
        ],
      );

      // Serializa o objeto para JSON
      final json = exercise.toJson();

      // Valida os dados principais do objeto Exercise
      expect(json['id'], 1);
      expect(json['name'], "Supino");
      expect(json['type'], "musculação");

      // Valida a lista de registros
      expect(json['records'], isA<List>());

      // Valida os dados do primeiro registro
      final recordJson = (json['records'] as List).first as Map<String, dynamic>;
      expect(recordJson['id'], 1);
      expect(recordJson['exerciseId'], 101);
      expect(recordJson['date'], "2024-12-07");
      expect(recordJson['series'], 3);
      expect(recordJson['weight'], {"S1": 10.5, "S2": 12.0, "S3": 15.0});
      expect(recordJson['time'], null);
      expect(recordJson['observation'], "Bom treino");
    });
  });
}
