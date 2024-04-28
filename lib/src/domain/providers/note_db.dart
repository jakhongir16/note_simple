import 'dart:io';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../data/model/note_list_model.dart';

class NoteProvider {

  // Database instance
  static Database? _database;

  // Database name
  static const String _databaseName = 'note.db';

  // Database version
  static const int _databaseVersion = 1;

  // Table name
  static const String _tableName = 'note';

  // Column names
  static const _columnId = 'id';
  static const _columnTitle = 'title';
  static const _columnDescription = 'description';


  // Initialize the database
  static Future<void> init() async {
    // Receive the path to the database directory
    final databasePath = join(await getDatabasesPath(), _databaseName);

    // just drop database code line
    // await deleteDatabase(databasePath); to remove

    // Check if database file exists
    final databaseExists = await File(databasePath).exists();

    if(!databaseExists){
      _database = await openDatabase(
        databasePath,
        version: _databaseVersion,
        onCreate: (db, version) async {
          await db.execute('CREATE TABLE $_tableName('
              '$_columnId INTEGER PRIMARY KEY AUTOINCREMENT,'
              '$_columnTitle TEXT,'
              '$_columnDescription TEXT'
              ')'
          );
        }
      );
    } else {
      // If the database exists, open it
      _database = await openDatabase(
        databasePath,
        version: _databaseVersion,
      );
    }
  }

  // Insert Note
  Future<void> insert(NoteModel note) async {
    try{
      // remove all the notes
      // await _database.!delete(_tableName);
      await _database!.insert(
          _tableName,
          note.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Update a note
  Future<void> update(NoteModel note) async {
    final Map<String, dynamic> noteMap = note.toMap();
    await _database!.update(
    _tableName,
    noteMap,
    where: '$_columnId = ?',
    whereArgs: [noteMap[_columnId]],
    );
  }

  // Delete a note
  Future<void> delete(int id) async {
    await _database!.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  // Get a note by id
  Future<NoteModel> noteById(int id) async {
    final List<Map<String, dynamic>> notes = await _database!.query(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );

    return NoteModel.fromMap(notes.first);
  }

  // Get all notes and return them as a JSON-encoded string
  Future<List<NoteModel>> notes() async {
    final List<Map<String, dynamic>> notes = await  _database!.query(_tableName);

    // Map each Map<String, dynamic> to a NoteModel object
    final List<NoteModel> noteList =
        notes.map((note) => NoteModel.fromMap(note)).toList();

    return noteList;
  }

  // Get last note
  Future<NoteModel> lastNote() async {
    final List<Map<String, dynamic>> notes = await _database!.query(_tableName);

    return NoteModel.fromMap(notes.last);
  }
}