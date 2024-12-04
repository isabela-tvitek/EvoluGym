import 'package:flutter/material.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/services/exercise_service.dart';
import 'package:dio/dio.dart';

class AddExerciseScreen extends StatefulWidget {
  final Exercise? exercise;  // Pode ser nulo se for um novo exercício

  AddExerciseScreen({this.exercise});

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _nameController = TextEditingController();
  String? _selectedType;  // Para armazenar o tipo selecionado
  bool _isSaving = false;

  final ExerciseService _exerciseService = ExerciseService(Dio());

  // Lista de tipos de exercício
  final List<String> _types = ["Inferiores", "Superiores", "Abdômen", "Cardio"];

  @override
  void initState() {
    super.initState();

    if (widget.exercise != null) {
      // Se for um exercício para editar, preenche os campos com os dados existentes
      _nameController.text = widget.exercise!.name;
      _selectedType = widget.exercise!.type; // Preenche o tipo
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
        // Adicionar um novo exercício
        final newExercise = Exercise(name: name, type: type);
        await _exerciseService.addExercise(newExercise);
      } else {
        // Editar um exercício existente
        final updatedExercise = Exercise(id: widget.exercise!.id, name: name, type: type);
        await _exerciseService.updateExercise(widget.exercise!.id!, updatedExercise); // Certifique-se de usar um ID não nulo
      }

      Navigator.pop(context, true); // Volta para a tela anterior indicando sucesso
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Exercício'),
            ),
            SizedBox(height: 20),
            // Dropdown para selecionar o tipo de exercício
            DropdownButton<String>(
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveExercise,
              child: _isSaving
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(widget.exercise == null ? 'Adicionar' : 'Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
