import 'package:firebase2/Services/Crud/Constants.dart';
import 'package:firebase2/Services/Crud/CrudExceptions.dart';
import 'package:firebase2/Services/Crud/UserDatabase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

Database? _db;

class NotesService {
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
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
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
    final db = getCurrentDB();
    final deletedCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
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
    final db = getCurrentDB();
    final results = await db.query(userTable,
        limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if (results.isEmpty) {
      throw UserNotFoundException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }
}
