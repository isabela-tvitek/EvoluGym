import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/services/api_service.dart';

class ExerciseService {
  final ApiService _apiService;

  ExerciseService(Dio dio) : _apiService = ApiService(dio);

  // Método para pegar todos os exercícios
  Future<List<Exercise>> getAllExercises() async {
    try {
      final exercises = await _apiService.getExercises();
      return exercises;
    } catch (e) {
      throw Exception('Erro ao carregar exercícios: $e');
    }
  }

  // Método para adicionar um novo exercício
  Future<void> addExercise(Exercise exercise) async {
    try {
      await _apiService.addExercise(exercise);
    } catch (e) {
      throw Exception('Erro ao adicionar exercício: $e');
    }
  }

  // Método para editar um exercício
  Future<void> updateExercise(int id, Exercise exercise) async {
    try {
      await _apiService.editExercise(id, exercise);
    } catch (e) {
      throw Exception('Erro ao editar exercício: $e');
    }
  }

  // Método para deletar um exercício
  Future<void> deleteExercise(int id) async {
    try {
      await _apiService.deleteExercise(id);
    } catch (e) {
      throw Exception('Erro ao deletar exercício: $e');
    }
  }
}
