import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/exercise.dart';

class ExerciseDatabase {
  static final ExerciseDatabase instance = ExerciseDatabase._init();
  static Database? _database;

  ExerciseDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('exercises.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');
  }


  Future<int> addExercise(Exercise exercise) async {
    final db = await instance.database;
    return await db.insert('exercises', exercise.toMap());
  }

  Future<List<Exercise>> getExercises() async {
    final db = await instance.database;
    final result = await db.query('exercises');
    return result.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<int> deleteExercise(int id) async {
    final db = await instance.database;
    return await db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await instance.database;
    return await db.update(
      'exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
