// helpers/database_helper.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static Database? _database;

  // Open or create a database
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            createdAt TEXT
          )
        ''');
      },
      version: 1,
    );
    return _database!;
  }

  // Insert a note
  static Future<void> insertNote(Note note) async {
    final db = await getDatabase();
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all notes
  static Future<List<Note>> getAllNotes() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Get a note by id
  static Future<Note?> getNoteById(int id) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  // Delete a note
  static Future<void> deleteNote(int id) async {
    final db = await getDatabase();
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
