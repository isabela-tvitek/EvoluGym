import 'package:flutter/material.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/services/exercise_service.dart';
import 'package:evolugym/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:evolugym/provider/theme_provider.dart';
import 'package:dio/dio.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar exercícios: $e')));
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar exclusão'),
              content: const Text(
                  'Você tem certeza de que deseja excluir este exercício?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Excluir'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Text(
          'Exercícios',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                onPressed: themeProvider.toggleTheme,
                icon: Icon(
                  themeProvider.isDarkTheme
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _exercises.length,
                itemBuilder: (context, index) {
                  final exercise = _exercises[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: themeProvider.isDarkTheme
                        ? const Color.fromARGB(255, 129, 126, 126)
                        : Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        exercise.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        exercise.type,
                        style: TextStyle(
                          color: themeProvider.isDarkTheme
                              ? Colors.white70
                              : Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.exerciseRecordRoute,
                          arguments: exercise,
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.green,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.addExerciseRoute,
                                arguments: exercise,
                              ).then((_) => _loadExercises());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () async {
                              final shouldDelete =
                                  await _showDeleteConfirmationDialog();
                              if (shouldDelete) {
                                await _exerciseService
                                    .deleteExercise(exercise.id!);
                                _loadExercises();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.addExerciseRoute,
          ).then((_) => _loadExercises());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
