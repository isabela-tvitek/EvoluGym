import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise_record.dart';
import 'package:evolugym/services/api_service.dart';

class ExerciseRecordService {
  final ApiService _apiService;

  ExerciseRecordService(Dio dio) : _apiService = ApiService(dio);

  Future<List<ExerciseRecord>> getExerciseRecords(int exerciseId) async {
    try {
      final records = await _apiService.getExerciseRecords(exerciseId);
      return records;
    } catch (e) {
      throw Exception('Erro ao carregar registros de evolução: $e');
    }
  }

  Future<void> addExerciseRecord(ExerciseRecord record) async {
    try {
      await _apiService.addExerciseRecord(record.exerciseId, record);
    } catch (e) {
      throw Exception('Erro ao adicionar registro de evolução: $e');
    }
  }

  Future<void> editExerciseRecord(int exerciseId, int recordId, ExerciseRecord record) async {
    try {
      await _apiService.editExerciseRecord(exerciseId, recordId, record);
    } catch (e) {
      throw Exception('Erro ao editar registro de evolução: $e');
    }
  }

  Future<void> deleteExerciseRecord(int exerciseId, int recordId) async {
    try {
      await _apiService.deleteExerciseRecord(exerciseId, recordId);
    } catch (e) {
      throw Exception('Erro ao deletar registro de evolução: $e');
    }
  }
}
