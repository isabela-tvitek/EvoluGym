import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise_record.dart';
import 'package:evolugym/services/exercise_record_service.dart';

import 'exercise_record_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late ExerciseRecordService exerciseRecordService;

  setUp(() {
    mockDio = MockDio();

    when(mockDio.options).thenReturn(BaseOptions());

    when(mockDio.fetch<List<dynamic>>(any)).thenAnswer((invocation) async {
      final options = invocation.positionalArguments.first as RequestOptions;

      if (options.path == '/exercises/1/records') {
        return Response<List<dynamic>>(
          requestOptions: options,
          data: [
            {
              'id': 1,
              'exerciseId': 1,
              'date': '2024-12-07',
              'series': 3,
              'weight': {'S1': 10.5, 'S2': 12.0},
              'time': null,
              'observation': 'Bom treino',
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

    exerciseRecordService = ExerciseRecordService(mockDio);
  });

  group('ExerciseRecordService', () {
    test('Deve retornar uma lista de registros ao chamar getExerciseRecords',
        () async {
      final result = await exerciseRecordService.getExerciseRecords(1);

      expect(result, isA<List<ExerciseRecord>>());
      expect(result.length, 1);
      expect(result[0].exerciseId, 1);
      verify(mockDio.fetch<List<dynamic>>(any)).called(1);
    });

    test('Deve lançar uma exceção ao falhar ao carregar registros', () async {
      when(mockDio.fetch<List<dynamic>>(any)).thenThrow(DioError(
        requestOptions: RequestOptions(path: '/exercises/1/records'),
        type: DioExceptionType.badResponse,
      ));

      expect(
        () => exerciseRecordService.getExerciseRecords(1),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'mensagem',
            contains('Erro ao carregar registros de evolução'),
          ),
        ),
      );
      verify(mockDio.fetch<List<dynamic>>(any)).called(1);
    });

    test('Deve adicionar um registro ao chamar addExerciseRecord', () async {
      final record = ExerciseRecord(
        id: null,
        exerciseId: 1,
        date: '2024-12-07',
        series: 3,
        weight: {'S1': 10.5, 'S2': 12.0},
        time: null,
        observation: 'Bom treino',
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/exercises/1/records'),
            statusCode: 201,
          ));

      await exerciseRecordService.addExerciseRecord(record);

      verify(mockDio.fetch(any)).called(1);
    });

    test('Deve editar um registro ao chamar editExerciseRecord', () async {
      final record = ExerciseRecord(
        id: 1,
        exerciseId: 1,
        date: '2024-12-07',
        series: 3,
        weight: {'S1': 10.5, 'S2': 12.0},
        time: null,
        observation: 'Atualizado',
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/exercises/1/records/1'),
            statusCode: 200,
          ));

      await exerciseRecordService.editExerciseRecord(1, 1, record);

      verify(mockDio.fetch(any)).called(1);
    });

    test('Deve deletar um registro ao chamar deleteExerciseRecord', () async {
      when(mockDio.fetch(any)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/exercises/1/records/1'),
            statusCode: 204,
          ));

      await exerciseRecordService.deleteExerciseRecord(1, 1);

      verify(mockDio.fetch(any)).called(1);
    });
  });
}
