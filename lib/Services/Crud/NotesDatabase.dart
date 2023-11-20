import 'package:firebase2/Services/Crud/Constants.dart';

class DatabaseNotes {
  final int id;
  final int userId;
  final String text;
  final bool isSynced;

  DatabaseNotes({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSynced,
  });

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[notesId] as int,
        userId = map[notesUserId] as int,
        text = map[notesText] as String,
        isSynced = (map[notesIsSynced] == 1) ? true : false;

  @override
  String toString() {
    return "Notes : id = $id, userId = $userId, text = $text, isSynced = $isSynced";
  }

  @override
  bool operator ==(covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
