import 'package:flutter/material.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/services/exercise_service.dart';
import 'package:dio/dio.dart';

class AddExerciseScreen extends StatefulWidget {
  final Exercise? exercise;

  AddExerciseScreen({this.exercise});

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _nameController = TextEditingController();
  String? _selectedType;
  bool _isSaving = false;

  final ExerciseService _exerciseService = ExerciseService(Dio());

  final List<String> _types = ["Inferiores", "Superiores", "Abdômen", "Cardio"];

  @override
  void initState() {
    super.initState();

    if (widget.exercise != null) {
      _nameController.text = widget.exercise!.name;
      _selectedType = widget.exercise!.type;
    }
  }

  Future<void> _saveExercise() async {
    final name = _nameController.text.trim();
    final type = _selectedType;

    if (name.isEmpty || type == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (widget.exercise == null) {
        final newExercise = Exercise(name: name, type: type);
        await _exerciseService.addExercise(newExercise);
      } else {
        final updatedExercise = Exercise(
          id: widget.exercise!.id,
          name: name,
          type: type,
        );
        await _exerciseService.updateExercise(widget.exercise!.id!, updatedExercise);
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar exercício: $e')));
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise == null ? 'Adicionar Exercício' : 'Editar Exercício'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Exercício'),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(
                labelText: "Tipo de Exercício",
                border: OutlineInputBorder(),
              ),
              child: DropdownButton<String>(
                value: _selectedType,
                hint: Text("Selecione o Tipo de Exercício"),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                items: _types.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveExercise,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF24BE9A),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _isSaving
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(widget.exercise == null ? 'Adicionar' : 'Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
