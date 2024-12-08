import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/services/exercise_service.dart';

import 'exercise_record_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late ExerciseService exerciseService;

  setUp(() {
    mockDio = MockDio();

    when(mockDio.options).thenReturn(BaseOptions());

    when(mockDio.fetch<List<dynamic>>(any)).thenAnswer((invocation) async {
      final options = invocation.positionalArguments.first as RequestOptions;

      if (options.path == '/exercises') {
        return Response<List<dynamic>>(
          requestOptions: options,
          data: [
            {
              'id': 1,
              'name': 'Supino',
              'type': 'Musculação',
              'records': [],
            },
            {
              'id': 2,
              'name': 'Corrida',
              'type': 'Cardio',
              'records': [],
            },
          ],
          statusCode: 200,
        );
      }

      throw DioError(
        requestOptions: options,
        type: DioExceptionType.badResponse,
      );
    });

    exerciseService = ExerciseService(mockDio);
  });

  group('ExerciseService', () {
    test('Deve retornar uma lista de exercícios ao chamar getAllExercises',
        () async {
      final result = await exerciseService.getAllExercises();

      expect(result, isA<List<Exercise>>());
      expect(result.length, 2);
      expect(result[0].name, 'Supino');
      verify(mockDio.fetch<List<dynamic>>(any)).called(1);
    });

    test('Deve lançar uma exceção ao falhar ao carregar exercícios', () async {
      when(mockDio.fetch<List<dynamic>>(any)).thenThrow(DioError(
        requestOptions: RequestOptions(path: '/exercises'),
        type: DioExceptionType.badResponse,
      ));

      expect(
        () => exerciseService.getAllExercises(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'mensagem',
            contains('Erro ao carregar exercícios'),
          ),
        ),
      );
      verify(mockDio.fetch<List<dynamic>>(any)).called(1);
    });

    test('Deve adicionar um exercício ao chamar addExercise', () async {
      final exercise = Exercise(
        id: null,
        name: 'Supino',
        type: 'Musculação',
        records: [],
      );

      when(mockDio.fetch(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/exercises'),
          statusCode: 201,
        ),
      );

      await exerciseService.addExercise(exercise);

      verify(mockDio.fetch(any)).called(1);
    });

    test('Deve editar um exercício ao chamar updateExercise', () async {
      final exercise =
          Exercise(id: 1, name: 'Corrida', type: 'Cardio', records: []);

      when(mockDio.fetch(any)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/exercises/1'),
            statusCode: 200,
          ));

      await exerciseService.updateExercise(1, exercise);

      verify(mockDio.fetch(any)).called(1);
    });

    test('Deve deletar um exercício ao chamar deleteExercise', () async {
      when(mockDio.fetch(any)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/exercises/1'),
            statusCode: 204,
          ));

      await exerciseService.deleteExercise(1);

      verify(mockDio.fetch(any)).called(1);
    });
  });
}
