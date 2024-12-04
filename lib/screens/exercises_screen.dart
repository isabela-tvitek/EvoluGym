import 'package:flutter/material.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/services/exercise_service.dart';
import 'package:dio/dio.dart';
import 'package:evolugym/screens/add_exercise_screen.dart';
import 'package:evolugym/screens/exercise_detail_screen.dart';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final ExerciseService _exerciseService = ExerciseService(Dio());
  List<Exercise> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final exercises = await _exerciseService.getAllExercises();
      setState(() {
        _exercises = exercises;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar exercícios: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercícios')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(exercise.type),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailScreen(exerciseId: exercise.id!),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.green,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddExerciseScreen(exercise: exercise),
                            ),
                          ).then((_) => _loadExercises());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () async {
                          await _exerciseService.deleteExercise(exercise.id!);
                          _loadExercises();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF24BE9A),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExerciseScreen()),
          ).then((_) => _loadExercises());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
