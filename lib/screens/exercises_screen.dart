import 'package:flutter/material.dart';
import '../services/exercise_service.dart';
import '../models/exercise.dart';
import '../routes/app_routes.dart';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final ExerciseService _exerciseService = ExerciseService();
  late Future<List<Exercise>> _exerciseList;

  @override
  void initState() {
    super.initState();
    _refreshExerciseList();
  }

  void _refreshExerciseList() {
    setState(() {
      _exerciseList = _exerciseService.getAllExercises(); // Atualiza a lista
    });
  }

  void _deleteExercise(int id) async {
    await _exerciseService.deleteExercise(id);
    _refreshExerciseList(); // Atualiza após deletar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios'),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: _exerciseList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar exercícios: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final exercises = snapshot.data!;
            if (exercises.isEmpty) {
              return Center(child: Text('Nenhum exercício cadastrado.'));
            } else {
              return ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text('Tipo: ${exercise.type}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteExercise(exercise.id!),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(child: Text('Nenhum dado disponível.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addExerciseRoute).then((value) {
            if (value == true) _refreshExerciseList();
          });
        },
        backgroundColor: const Color(0xFF24BE9A),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
