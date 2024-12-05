import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/models/exercise_record.dart';
import 'package:evolugym/screens/add_exercise_record_screen.dart';
import 'package:evolugym/screens/exercise_record_detail_screen.dart'; // Novo import
import 'package:evolugym/services/exercise_record_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      await _exerciseRecordService.deleteExerciseRecord(widget.exercise.id!, recordId);
      setState(() {
        _recordsFuture =
            _exerciseRecordService.getExerciseRecords(widget.exercise.id!);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao excluir o registro')));
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
        builder: (context) => ExerciseRecordDetailScreen(record: record),
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
      appBar: AppBar(
        title: Text('Registros de ${widget.exercise.name}'),
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
              return Column(
                children: [
                  ListTile(
                    title: Text('Data: ${_formatDate(record.date)}'),
                    subtitle: Text(
                        record.observation != null ? 'Observação: ${record.observation}' : ''),
                    onTap: () {
                      _navigateToRecordDetailScreen(record);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                  const Divider(color: Colors.grey),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF24BE9A),
        onPressed: () => _navigateToAddRecordScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
