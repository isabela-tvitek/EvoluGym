import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/screens/add_exercise_record_screen.dart';
import 'package:evolugym/screens/exercise_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:evolugym/screens/add_exercise_screen.dart';
import 'package:evolugym/screens/exercises_screen.dart';
import 'package:evolugym/screens/home_screen.dart';

class AppRoutes {
  static const String homeRoute = '/';
  static const String exercisesRoute = '/exercicios';
  static const String addExerciseRoute = '/add-exercicio';
  static const String exerciseRecordRoute = '/detalhes-exercicio';
  static const String exerciseRecordRecordRoute = '/detalhes-registro';
  static const String addExerciseRecordRoute = '/add-record-exercicio';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case exercisesRoute:
        return MaterialPageRoute(builder: (_) => const ExercisesScreen());
      case addExerciseRoute:
        return MaterialPageRoute(builder: (_) => const AddExerciseScreen());
      case exerciseRecordRoute:
        final Exercise exercise = settings.arguments as Exercise;
        return MaterialPageRoute(
          builder: (_) => ExerciseRecordScreen(exercise: exercise),
        );
      case addExerciseRecordRoute:
        final Exercise exercise = settings.arguments as Exercise;
        return MaterialPageRoute(
          builder: (_) => AddExerciseRecordScreen(exercise: exercise),
      );
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(title: const Text("Tela Não Encontrada")),
            body: const Center(child: Text("Tela não encontrada")),
          );
        });
    }
  }
}
