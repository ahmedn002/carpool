import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  static Database? myDB;
  static const version = 2;

  static Future<Database?> myDBCheck() async {
    if (myDB == null) {
      myDB = await initiateDatabase();
      return myDB;
    } else {
      return myDB;
    }
  }

  static Future<int> insertUser(Map<String, dynamic> userData) async {
    Database? db = await myDBCheck();
    return await db!.insert('USERS', userData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static initiateDatabase() async {
    String dbDestination = await getDatabasesPath();
    String dbPath = join(dbDestination, 'carpool3.db');
    Database myDatabase1 = await openDatabase(
      dbPath,
      version: version,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE IF NOT EXISTS 'USERS'(
          'ID' TEXT NOT NULL PRIMARY KEY,
          'NAME' TEXT NOT NULL,
          'EMAIL' TEXT NOT NULL,
          'PROFILE_PIC' TEXT NOT NULL,
          'PASSWORD' TEXT NOT NULL,
          'BALANCE' INTEGER NOT NULL)
        ''');
      },
    );
    return myDatabase1;
  }

  static Future<List<Map<String, dynamic>>> reading(String sql) async {
    Database? someVariable = await myDBCheck();
    var response = await someVariable!.rawQuery(sql);
    return response;
  }

  static updating(sql) async {
    Database? checker = await myDBCheck();
    var response = checker!.rawUpdate(sql);
    return response;
  }
}
