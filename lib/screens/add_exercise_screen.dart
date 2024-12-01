import 'package:flutter/material.dart';
import '../services/exercise_service.dart';

class AddExerciseScreen extends StatefulWidget {
  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _nameController = TextEditingController();
  final ExerciseService _exerciseService = ExerciseService();
  String _selectedType = 'Superiores';

  final List<String> _types = [
    'Superiores',
    'Inferiores',
    'Cardio',
    'Abdômen',
  ];

  void _saveExercise() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira o nome do exercício.')),
      );
      return;
    }

    await _exerciseService.addExercise(name, _selectedType);

    Navigator.pop(context, true); // Retorna para a tela anterior com sucesso
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Exercício'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nome', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _nameController),
            const SizedBox(height: 20),
            const Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _saveExercise,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF24BE9A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('SALVAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
