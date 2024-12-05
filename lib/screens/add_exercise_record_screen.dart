import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/models/exercise_record.dart';
import 'package:evolugym/services/exercise_record_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExerciseRecordScreen extends StatefulWidget {
  final Exercise exercise;
  final ExerciseRecord? record;

  const AddExerciseRecordScreen({super.key, required this.exercise, this.record});

  @override
  _AddExerciseRecordScreenState createState() =>
      _AddExerciseRecordScreenState();
}

class _AddExerciseRecordScreenState extends State<AddExerciseRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _date;
  late int _series;
  late Map<String, double> _weight;
  late String _observation;
  late ExerciseRecordService _exerciseRecordService;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _seriesController = TextEditingController();

  bool _isSeriesReduced = false;

  @override
  void initState() {
    super.initState();
    _exerciseRecordService = ExerciseRecordService(Dio());

    if (widget.record != null) {
      _date = widget.record!.date;
      _series = widget.record!.series;
      _weight = widget.record!.weight;
      _observation = widget.record!.observation!;
      _dateController.text = _formatDateForDisplay(_date);
      _seriesController.text = _series.toString();
    } else {
      _date = '';
      _weight = {};
      _series = 1;
      _seriesController.text = '1';
      _observation = '';
    }
  }

  String _formatDateForDisplay(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = _date.isEmpty ? DateTime.now() : DateTime.parse(_date);
    DateTime firstDate = DateTime(1800);
    DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _date = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _updateWeightFields() {
    setState(() {
      int previousSeries = _series;
      _series = int.parse(_seriesController.text);

      _isSeriesReduced = _series < previousSeries;

      if (_weight.length < _series) {
        for (int i = _weight.length; i < _series; i++) {
          _weight['S${i + 1}'] = 0.0;
        }
      } else if (_weight.length > _series) {
        _weight.removeWhere((key, value) => int.parse(key.substring(1)) > _series);
      }

      if (_isSeriesReduced) {
        _observation = '';
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final record = ExerciseRecord(
        id: widget.record?.id,
        exerciseId: widget.exercise.id!,
        date: _date,
        series: _series,
        weight: _weight,
        observation: _observation,
      );

      if (widget.record == null) {
        _exerciseRecordService.addExerciseRecord(record).then((_) {
          Navigator.pop(context, true);
        }).catchError((e) {
          String errorMessage = 'Erro ao adicionar registro';
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
        });
      } else {
        _exerciseRecordService.editExerciseRecord(
          widget.exercise.id!,
          widget.record!.id!,
          record,
        ).then((_) {
          Navigator.pop(context, true);
        }).catchError((e) {
          String errorMessage = 'Erro ao editar registro';
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
        });
      }
    }
  }

  List<Widget> _buildWeightFields() {
    List<Widget> weightFields = [];
    for (int i = 1; i <= _series; i++) {
      weightFields.add(
        TextFormField(
          initialValue: _weight['S$i']?.toString(),
          decoration: InputDecoration(labelText: 'Peso S$i'),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onSaved: (value) {
            if (value != null && value.isNotEmpty) {
              _weight['S$i'] = double.parse(value);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Informe o peso para a série $i';
            }
            return null;
          },
        ),
      );
    }
    return weightFields;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'Adicionar Registro' : 'Editar Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                readOnly: true,
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Data'),
                onTap: () {
                  _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a data';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.record?.observation,
                decoration: const InputDecoration(labelText: 'Observação'),
                onSaved: (value) => _observation = value!,
              ),
              TextFormField(
                controller: _seriesController,
                decoration: const InputDecoration(labelText: 'Séries'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _updateWeightFields();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o número de séries';
                  }
                  return null;
                },
              ),
              ..._buildWeightFields(),
              const SizedBox(height: 20),
              const Spacer(),
              ElevatedButton(
                onPressed: _submitForm,
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
                child: Text(widget.record == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
