const userId = 'id';
const userEmail = 'email';

const notesId = 'id';
const notesUserId = 'user_id';
const notesText = 'text';
const notesIsSynced = 'is_synced';

const dbname = 'notes.db';
const noteTable = 'note';
const userTable = 'user';

const createUserTable = '''CREATE TABLE IF NOT EXIST "User" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
  );''';

const createNotesTable = '''CREATE TABLE IF NOT EXIST "Notes" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "User"("id")
  );''';
