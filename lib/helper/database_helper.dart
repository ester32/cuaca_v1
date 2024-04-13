import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:cuaca_v1/model/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)',
        );
      },
    );
  }

  Future<int> insert(Note note) async {
    Database db = await database;
    return await db.insert('notes', note.toMapWithoutId());
  }

  Future<int> update(Note note) async {
    Database db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<List<Note>> getAllNotes() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (index) {
      return Note.fromMap(maps[index]);
    });
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}