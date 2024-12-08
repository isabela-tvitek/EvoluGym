import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/models/exercise_record.dart';
import 'package:evolugym/screens/add_exercise_record_screen.dart';
import 'package:evolugym/screens/exercise_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:evolugym/screens/add_exercise_screen.dart';
import 'package:evolugym/screens/exercises_screen.dart';
import 'package:evolugym/screens/home_screen.dart';
import 'package:evolugym/screens/exercise_record_detail_screen.dart';

class AppRoutes {
  static const String homeRoute = '/';
  static const String exercisesRoute = '/exercicios';
  static const String addExerciseRoute = '/add-exercicio';
  static const String exerciseRecordRoute = '/detalhes-exercicio';
  static const String exerciseRecordDetailRoute = '/detalhes-registro';
  static const String addExerciseRecordRoute = '/add-record-exercicio';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case exercisesRoute:
        return MaterialPageRoute(builder: (_) => const ExercisesScreen());
      case AppRoutes.addExerciseRoute:
        final Exercise? exercise = settings.arguments as Exercise?;
        return MaterialPageRoute(
          builder: (_) => AddExerciseScreen(exercise: exercise),
        );
      case exerciseRecordRoute:
        final Exercise exercise = settings.arguments as Exercise;
        return MaterialPageRoute(
          builder: (_) => ExerciseRecordScreen(exercise: exercise),
        );
      case addExerciseRecordRoute:
        final args = settings.arguments as Map<String, dynamic>;
        final exercise = args['exercise'] as Exercise;
        final record = args['record'] as ExerciseRecord?;
        return MaterialPageRoute(
          builder: (_) => AddExerciseRecordScreen(
            exercise: exercise,
            record: record,
          ),
        );
      case exerciseRecordDetailRoute:
        final arguments = settings.arguments as Map<String, dynamic>;
        final record = arguments['record'] as ExerciseRecord;
        final exercise = arguments['exercise'] as Exercise;
        return MaterialPageRoute(
          builder: (_) =>
              ExerciseRecordDetailScreen(record: record, exercise: exercise),
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
