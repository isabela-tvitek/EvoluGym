import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/models/exercise_record.dart';
import 'package:evolugym/provider/theme_provider.dart';
import 'package:evolugym/screens/add_exercise_record_screen.dart';
import 'package:evolugym/screens/exercise_record_detail_screen.dart';
import 'package:evolugym/services/exercise_record_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExerciseRecordScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseRecordScreen({super.key, required this.exercise});

  @override
  _ExerciseRecordScreenState createState() => _ExerciseRecordScreenState();
}

class _ExerciseRecordScreenState extends State<ExerciseRecordScreen> {
  late ExerciseRecordService _exerciseRecordService;
  late Future<List<ExerciseRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _exerciseRecordService = ExerciseRecordService(Dio());
    _recordsFuture =
        _exerciseRecordService.getExerciseRecords(widget.exercise.id!);
  }

  Future<void> _deleteRecord(int recordId) async {
    try {
      await _exerciseRecordService.deleteExerciseRecord(
          widget.exercise.id!, recordId);
      setState(() {
        _recordsFuture =
            _exerciseRecordService.getExerciseRecords(widget.exercise.id!);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao excluir o registro')));
    }
  }

  void _navigateToAddRecordScreen({ExerciseRecord? record}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExerciseRecordScreen(
          exercise: widget.exercise,
          record: record,
        ),
      ),
    );

    if (result != null && result) {
      setState(() {
        _recordsFuture =
            _exerciseRecordService.getExerciseRecords(widget.exercise.id!);
      });
    }
  }

  void _navigateToRecordDetailScreen(ExerciseRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseRecordDetailScreen(
          record: record,
          exercise: widget.exercise,
        ),
      ),
    );
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Registros de ${widget.exercise.name}'),
        backgroundColor: const Color(0xFF24BE9A),
        elevation: 4,
        centerTitle: true,
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
      body: FutureBuilder<List<ExerciseRecord>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os registros.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum registro encontrado.'));
          }

          final records = snapshot.data!;

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 129, 126, 126)
                    : Colors.white,
                child: InkWell(
                  onTap: () {
                    _navigateToRecordDetailScreen(record);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.fitness_center,
                          color: Color(0xFF24BE9A),
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data: ${_formatDate(record.date)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                record.observation != null
                                    ? 'Observação: ${record.observation}'
                                    : 'Sem Observação',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.green,
                          onPressed: () {
                            _navigateToAddRecordScreen(record: record);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            _deleteRecord(record.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddRecordScreen(),
        backgroundColor: Color(0xFF24BE9A),
        child: const Icon(Icons.add),
      ),
    );
  }
}
