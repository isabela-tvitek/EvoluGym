import 'package:flutter/material.dart';
import 'package:evolugym/models/exercise_detail.dart';
import 'package:evolugym/services/exercise_detail_service.dart';
import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise.dart';

class AddExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  AddExerciseDetailScreen({required this.exercise});

  @override
  _AddExerciseDetailScreenState createState() => _AddExerciseDetailScreenState();
}

class _AddExerciseDetailScreenState extends State<AddExerciseDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _seriesController = TextEditingController();
  final _weightController = TextEditingController();
  final _observationController = TextEditingController();

  final ExerciseDetailService _exerciseDetailService = ExerciseDetailService(Dio());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Detalhe do Exercício'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Data'),
                validator: (value) => value!.isEmpty ? 'Digite uma data' : null,
              ),
              TextFormField(
                controller: _seriesController,
                decoration: InputDecoration(labelText: 'Número de Séries'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Digite o número de séries' : null,
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Digite o peso' : null,
              ),
              TextFormField(
                controller: _observationController,
                decoration: InputDecoration(labelText: 'Observação'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecord,
                child: Text('Salvar Registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final newRecord = ExerciseDetail(
        exerciseId: widget.exercise.id!,
        date: _dateController.text,
        series: int.parse(_seriesController.text),
        weight: double.parse(_weightController.text),
        observation: _observationController.text,
      );
      try {
        await _exerciseDetailService.addExerciseDetail(newRecord);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao adicionar registro: $e')));
      }
    }
  }
}
