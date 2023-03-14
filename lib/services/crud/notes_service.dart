import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'crud_exceptions.dart';

class DatabaseAlreadyOpenException implements Exception{}

class NotesService{
  Database? _db;

  // opening the database
  // if database does not exist, create db and tables
  Future<void> open() async{
    if(_db!=null) throw DatabaseAlreadyOpenException();
    try {
      final docPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);

    } on MissingPlatformDirectoryException{
      throw UnableToGetDocumentsDirectory();
    }
  }

  // close db
  Future<void> close() async{
    final db = _db;
    if(db==null) {
      throw DatabaseNotOpenException();
    } else {
      await db.close();
      _db = null;
    }

  }

  Database _getDatabaseOrThrow(){
    final db = _db;
    if(db!=null) return db;
    throw DatabaseNotOpenException();
  }

  Future<DatabaseUser> createUser({required String email}) async{
    final db = _getDatabaseOrThrow();
    // first check if already exists
    final results = await db.query(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()]
    );
    if(results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId = await db.insert(userTable, {emailColumn : email.toLowerCase()} );
    
    return DatabaseUser(userId, email);

  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseUser> getUser({required String email}) async{
    final db = _getDatabaseOrThrow();
    final res = await db.query(
        userTable,
        where: "email = ?",
        whereArgs: [email.toLowerCase()]);

    if(res.isEmpty){
      throw CouldNotFindUserException();
    }
    return DatabaseUser.fromRow(res[0]);
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner, required text}) async {
    final db = _getDatabaseOrThrow();

    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }


    final noteId = await db.insert(noteTable, {
      userIdColumn : owner.id,
      textColumn : text,
      isSyncedColumn : true
    });

    final note = DatabaseNote(noteId, owner.id, text, true);

    return note;

  }

  Future<void> deleteNote({required int id}) async  {
    final db = _getDatabaseOrThrow();

    final res = await db.delete(
        noteTable, where : "id = ?", whereArgs: [id]);

    if(res==0) throw CouldNotDeleteNoteException();

  }

  Future<void> deleteAllNotes() async{
    final db = _getDatabaseOrThrow();
    
    await db.delete(noteTable);
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    
    final res = await db.query(noteTable);
    return res.map((notesRow) => DatabaseNote.fromRow(notesRow));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  Future<DatabaseNote> updateNote({required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);

    final count = await db.update(noteTable, {textColumn : text},
        where: "id = ?", whereArgs: [note.id]);

    if(count == 0){
      throw CouldNotUpdateNotException();
    } else {
      return await getNote(id: note.id);
    }
  }
}



class DatabaseUser{
  final int id;
  final String email;
  DatabaseUser(this.id, this.email);

  DatabaseUser.fromRow(Map<String, Object?> map) :
        id = map[idColumn] as int ,
        email = map[emailColumn] as String;

  @override
  String toString() {
    return 'Person, id = $id, email = $email';
  }

  @override bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

}

class DatabaseNote{

  final int id;
  final int userId;
  final String text;
  final bool isSynced;

  DatabaseNote(this.id, this.userId, this.text, this.isSynced);

  DatabaseNote.fromRow(Map<String, Object?> map) :
        id = map[idColumn] as int ,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSynced = (map[isSyncedColumn] as int) == 1 ? true : false;

  @override
  String toString() {
    return 'Person, id = $id, userId = $userId, isSynced = $isSynced';
  }

  @override bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

}

const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const idColumn = "id" ;
const emailColumn = "email" ;
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedColumn = "is_synced";

const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';