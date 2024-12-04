import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/services/api_service.dart';

class ExerciseService {
  final ApiService _apiService;

  ExerciseService(Dio dio) : _apiService = ApiService(dio);

  Future<List<Exercise>> getAllExercises() async {
    try {
      final exercises = await _apiService.getExercises();
      return exercises;
    } catch (e) {
      throw Exception('Erro ao carregar exercícios: $e');
    }
  }

  Future<void> addExercise(Exercise exercise) async {
    try {
      await _apiService.addExercise(exercise);
    } catch (e) {
      throw Exception('Erro ao adicionar exercício: $e');
    }
  }

  Future<void> updateExercise(int id, Exercise exercise) async {
    try {
      await _apiService.editExercise(id, exercise);
    } catch (e) {
      throw Exception('Erro ao editar exercício: $e');
    }
  }

  Future<void> deleteExercise(int id) async {
    try {
      await _apiService.deleteExercise(id);
    } catch (e) {
      throw Exception('Erro ao deletar exercício: $e');
    }
  }

  Future<Exercise> getExerciseById(int id) async {
    try {
      var _dio;
      final response = await _dio.get('https://api.example.com/exercises/$id');
      return Exercise.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao carregar os detalhes do exercício: $e');
    }
  }
}
