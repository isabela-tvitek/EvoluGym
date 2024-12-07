import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/models/exercise_record.dart';
import 'package:evolugym/provider/theme_provider.dart';
import 'package:evolugym/services/exercise_record_service.dart';
import 'package:evolugym/widgets/custom_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddExerciseRecordScreen extends StatefulWidget {
  final Exercise exercise;
  final ExerciseRecord? record;

  const AddExerciseRecordScreen(
      {super.key, required this.exercise, this.record});

  @override
  _AddExerciseRecordScreenState createState() =>
      _AddExerciseRecordScreenState();
}

class _AddExerciseRecordScreenState extends State<AddExerciseRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _date;
  late int _series;
  late Map<String, double> _weight;
  late Map<String, int> _time;
  late String _observation;
  late ExerciseRecordService _exerciseRecordService;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();

  bool _isSeriesReduced = false;

  @override
  void initState() {
    super.initState();
    _exerciseRecordService = ExerciseRecordService(Dio());

    if (widget.record != null) {
      _date = widget.record!.date;
      _series = widget.record!.series;

      if (widget.exercise.type.toLowerCase() == 'cardio') {
        _time = Map<String, int>.from(widget.record!.time!);
        _weight = {};
      } else {
        _weight = Map<String, double>.from(widget.record!.weight!);
        _time = {};
      }

      _observation = widget.record!.observation!;
      _dateController.text = _formatDateForDisplay(_date);
      _seriesController.text = _series.toString();
    } else {
      _date = '';
      _time = {};
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
    DateTime initialDate =
        _date.isEmpty ? DateTime.now() : DateTime.parse(_date);
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
        _date =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _updateWeightFields() {
    setState(() {
      int previousSeries = _series;
      _series = int.parse(_seriesController.text);

      _isSeriesReduced = _series < previousSeries;

      if (widget.exercise.type.toLowerCase() == 'cardio') {
        if (_time.length < _series) {
          for (int i = _time.length; i < _series; i++) {
            _time['S${i + 1}'] = 0;
          }
        } else if (_time.length > _series) {
          _time.removeWhere(
              (key, value) => int.parse(key.substring(1)) > _series);
        }
      } else {
        if (_weight.length < _series) {
          for (int i = _weight.length; i < _series; i++) {
            _weight['S${i + 1}'] = 0.0;
          }
        } else if (_weight.length > _series) {
          _weight.removeWhere(
              (key, value) => int.parse(key.substring(1)) > _series);
        }
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
        weight: widget.exercise.type.toLowerCase() == 'cardio'
            ? _time.map((key, value) => MapEntry(key, value.toDouble()))
            : _weight,
        observation: _observation,
        time: widget.exercise.type.toLowerCase() == 'cardio' ? _time : {},
      );

      if (widget.record == null) {
        _exerciseRecordService.addExerciseRecord(record).then((_) {
          Navigator.pop(context, true);
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao adicionar registro')));
        });
      } else {
        _exerciseRecordService
            .editExerciseRecord(
          widget.exercise.id!,
          widget.record!.id!,
          record,
        )
            .then((_) {
          Navigator.pop(context, true);
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao editar registro')));
        });
      }
    }
  }

  List<Widget> _buildWeightOrTimeFields() {
    final theme = Theme.of(context);

    List<Widget> fields = [];
    for (int i = 1; i <= _series; i++) {
      if (widget.exercise.type.toLowerCase() == 'cardio') {
        fields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              initialValue: _time['S$i']?.toString(),
              decoration: InputDecoration(
                labelText: 'Tempo S$i (segundos)',
                labelStyle: TextStyle(color: Colors.grey[600]),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
              ),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _time['S$i'] = int.parse(value);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o tempo para a série $i';
                }
                return null;
              },
            ),
          ),
        );
      } else {
        fields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              initialValue: _weight['S$i']?.toString(),
              decoration: InputDecoration(
                labelText: 'Peso S$i',
                labelStyle: TextStyle(color: Colors.grey[600]),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
          ),
        );
      }
    }
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.record == null ? 'Adicionar Registro' : 'Editar Registro',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  readOnly: true,
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: _observation,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Observação',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                  ),
                  onSaved: (value) {
                    _observation = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _seriesController,
                  decoration: InputDecoration(
                    labelText: 'Número de Séries',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _series = int.parse(value ?? '1');
                  },
                  onChanged: (value) {
                    _updateWeightFields();
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  children: _buildWeightOrTimeFields(),
                ),
                const SizedBox(height: 20),
                if (widget.exercise.type.toLowerCase() == 'cardio')
                  CustomerTimerWidget(
                    onTimeChanged: (time) {
                      setState(() {});
                    },
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(widget.record == null ? 'Adicionar' : 'Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
