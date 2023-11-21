import 'dart:async';

import 'package:firebase2/Services/Crud/Constants.dart';
import 'package:firebase2/Services/Crud/CrudExceptions.dart';
import 'package:firebase2/Services/Crud/NotesDatabase.dart';
import 'package:firebase2/Services/Crud/UserDatabase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

Database? _db;

class NotesService {
  NotesService._sharedInstance();
  static final NotesService _shared = NotesService._sharedInstance();
  factory NotesService() => _shared;

  List<DatabaseNotes> _notes = [];

  final _noteStreamController =
      StreamController<List<DatabaseNotes>>.broadcast();

  Stream<List<DatabaseNotes>> get allNotes => _noteStreamController.stream;

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes;
    _noteStreamController.add(_notes);
  }

  Future<DatabaseNotes> createNote({required DatabaseUser user}) async {
    await _ensureDBisOpen();
    final db = getCurrentDB();

    final dbUser = await getUser(email: user.email);

    if (dbUser.id != user.id) {
      throw UserNotFoundException();
    }

    const text = '';

    final noteId = await db.insert(
        noteTable, {notesUserId: user.id, notesText: text, notesIsSynced: 1});
    //print(noteId);

    final note =
        DatabaseNotes(id: noteId, userId: user.id, text: text, isSynced: true);

    _notes.add(note);
    _noteStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDBisOpen();
    final db = getCurrentDB();

    final results =
        await db.delete(noteTable, where: 'id = ?', whereArgs: [id]);

    if (results == 0) {
      throw NoteNotFoundException();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _noteStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDBisOpen();
    final db = getCurrentDB();
    final numberOfRows = await db.delete(noteTable);
    _notes = [];
    _noteStreamController.add(_notes);
    return numberOfRows;
  }

  Future<DatabaseNotes> getNote({required int id}) async {
    await _ensureDBisOpen();
    final db = getCurrentDB();

    final notes =
        await db.query(noteTable, limit: 1, where: 'id = ?', whereArgs: [id]);

    if (notes.isEmpty) {
      throw NoteNotFoundException();
    } else {
      final note = DatabaseNotes.fromRow(notes.first);

      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _noteStreamController.add(_notes);

      return note;
    }
  }

  Future<List<DatabaseNotes>> getAllNotes() async {
    await _ensureDBisOpen();
    final db = getCurrentDB();
    try {
      final allNotes = await db.query(noteTable);
      final notes = allNotes.map((e) => DatabaseNotes.fromRow(e));
      return notes.toList();
    } on DatabaseException {
      throw NoteNotFoundException();
    }
  }

  Future<DatabaseNotes> updateNote(
      {required DatabaseNotes note, required String text}) async {
    await _ensureDBisOpen();
    final db = getCurrentDB();
    //making sure note exist
    await getNote(id: note.id);

    final updateCount =
        await db.update(noteTable, {notesText: text, notesIsSynced: 0});

    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _noteStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<void> _ensureDBisOpen() async {
    try {
      await open();
    } on DatabaseIsOpenException {
      return;
      //
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseIsOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbname);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createUserTable);
      await db.execute(createNotesTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Database getCurrentDB() {
    final db = _db;
    if (db != null) {
      return db;
    } else {
      throw DatabaseIsNotOpenException();
    }
  }

  Future<void> deleteUser(String email) async {
    await _ensureDBisOpen();
    final db = getCurrentDB();
    final deletedCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDBisOpen();
    final db = getCurrentDB();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserExistException();
    }

    final id = await db.insert(userTable, {userEmail: email.toLowerCase()});

    return DatabaseUser(id: id, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDBisOpen();
    final db = getCurrentDB();
    final results = await db.query(userTable,
        limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (results.isEmpty) {
      throw UserNotFoundException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on UserNotFoundException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }
}
