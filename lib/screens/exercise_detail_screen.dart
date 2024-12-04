import 'package:flutter/material.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/services/exercise_service.dart';
import 'package:dio/dio.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final int exerciseId;

  ExerciseDetailScreen({required this.exerciseId});

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late Future<Exercise> _exerciseDetails;

  final ExerciseService _exerciseService = ExerciseService(Dio());

  @override
  void initState() {
    super.initState();
    _exerciseDetails = _exerciseService.getExerciseById(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes do Exercício")),
      body: FutureBuilder<Exercise>(
        future: _exerciseDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os detalhes do exercício'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Nenhum dado encontrado'));
          } else {
            final exercise = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${exercise.name}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Tipo: ${exercise.type}', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
