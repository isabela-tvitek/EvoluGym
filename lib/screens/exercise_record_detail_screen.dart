import 'package:evolugym/models/exercise_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExerciseRecordDetailScreen extends StatelessWidget {
  final ExerciseRecord record;

  const ExerciseRecordDetailScreen({super.key, required this.record});

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final pesoPorSerie = record.weight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data: ${_formatDate(record.date)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Observação:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              record.observation ?? 'Sem observação',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Série:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${record.series}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Peso por Série (Kg):',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 1; i <= record.series; i++) 
                  Text(
                    'S$i: ${pesoPorSerie['S$i']?.toStringAsFixed(1) ?? '0.0'} kg',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
