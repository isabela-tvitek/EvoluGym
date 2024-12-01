import 'dart:io';
import 'package:flutter/foundation.dart';
import '../database/exercise_database.dart';
import '../models/exercise.dart';

class ExerciseService {
  final List<Exercise> _webStorage = []; // Armazenamento temporário para o Web
  final ExerciseDatabase _db = ExerciseDatabase.instance;

  // Adicionar novo exercício
  Future<void> addExercise(String name, String type) async {
    if (kIsWeb) {
      // Armazena temporariamente no Web
      final newExercise = Exercise(
        id: _webStorage.isNotEmpty ? _webStorage.last.id! + 1 : 1, // Incrementa o ID
        name: name,
        type: type,
      );
      _webStorage.add(newExercise);
    } else {
      // Usa SQLite no Mobile/Desktop
      final newExercise = Exercise(name: name, type: type);
      await _db.addExercise(newExercise);
    }
  }

  // Buscar todos os exercícios
  Future<List<Exercise>> getAllExercises() async {
    if (kIsWeb) {
      // Retorna do armazenamento temporário no Web
      return Future.value(_webStorage);
    } else {
      // Retorna do banco SQLite no Mobile/Desktop
      return await _db.getExercises();
    }
  }

  // Deletar exercício
  Future<void> deleteExercise(int id) async {
    if (kIsWeb) {
      // Remove do armazenamento temporário no Web
      _webStorage.removeWhere((exercise) => exercise.id == id);
    } else {
      // Remove do banco SQLite no Mobile/Desktop
      await _db.deleteExercise(id);
    }
  }

  // Atualizar exercício
  Future<void> updateExercise(int id, String name, String type) async {
    if (kIsWeb) {
      // Atualiza no armazenamento temporário no Web
      final index = _webStorage.indexWhere((exercise) => exercise.id == id);
      if (index != -1) {
        _webStorage[index] = Exercise(id: id, name: name, type: type);
      }
    } else {
      // Atualiza no banco SQLite no Mobile/Desktop
      final updatedExercise = Exercise(id: id, name: name, type: type);
      await _db.updateExercise(updatedExercise);
    }
  }
}
