import 'package:evolugym/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/services/exercise_service.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class AddExerciseScreen extends StatefulWidget {
  final Exercise? exercise;

  const AddExerciseScreen({super.key, this.exercise});

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
      if (_types.contains(widget.exercise!.type)) {
        _selectedType = widget.exercise!.type;
      } else {
        _selectedType = null;
      }
    }
  }

  Future<void> _saveExercise() async {
    final name = _nameController.text.trim();
    final type = _selectedType;

    if (name.isEmpty || type == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (widget.exercise == null) {
        final newExercise = Exercise(
          id: null,
          name: name,
          type: type,
          records: [],
        );
        await _exerciseService.addExercise(newExercise);
      } else {
        final updatedExercise = Exercise(
          id: widget.exercise!.id,
          name: name,
          type: type,
          records: widget.exercise!.records,
        );
        await _exerciseService.updateExercise(
            widget.exercise!.id!, updatedExercise);
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar exercício: $e')));
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputDecoration = InputDecoration(
      labelText: "Nome do Exercício",
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: theme.colorScheme.primary.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF24BE9A),
        title: Text(
          widget.exercise == null ? 'Adicionar Exercício' : 'Editar Exercício',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: inputDecoration.copyWith(
                  labelText: 'Nome do Exercício',
                ),
              ),
              const SizedBox(height: 20),
              InputDecorator(
                decoration: inputDecoration.copyWith(
                  labelText: 'Tipo de Exercício',
                ),
                child: DropdownButton<String>(
                  value: _selectedType,
                  hint: const Text("Selecione o Tipo de Exercício"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  isExpanded: true,
                  items: _types.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 180),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveExercise,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF24BE9A),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.exercise == null ? 'Adicionar' : 'Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
