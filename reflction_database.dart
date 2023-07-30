import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:units_reflection/Models/user.dart';
import '../Models/reflection.dart';
import 'package:path/path.dart';

class ReflectionDatabase {
  static final ReflectionDatabase instance = ReflectionDatabase._initialize();
  static Database? _database;
  ReflectionDatabase._initialize();

  Future _createDB(Database db, int version) async {
    final userUsernameType = "TEXT PRIMARY KEY NOT NULL";
    final textType = "TEXT NOT NULL";
    final boolType = "BOOLEAN NOT NULL";

    await db.execute('''CREATE TABLE $userTable (
        ${UserFields.username} $userUsernameType,
        ${UserFields.name} $textType
    )''');

    await db.execute('''CREATE TABLE $reflectionTable (
        ${ReflectionFields.username} $textType,
        ${ReflectionFields.title} $textType,
        ${ReflectionFields.done} $boolType,
        ${ReflectionFields.created} $textType,
        FOREIGN KEY (${ReflectionFields.username}) REFERENCES $userTable (${UserFields.username})
    )''');
  }

  Future _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future<Database> _initDB(String filename) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filename);
    return await openDatabase(path,
        version: 1, onCreate: _createDB, onConfigure: _onConfigure);
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDB("reflection.db");
      return _database;
    }
  }

  Future<User> createUser(User user) async {
    final db = await instance.database;

    await db!.insert(userTable, user.toJson());
    return user;
  }

  Future<User> getUser(String username) async {
    final db = await instance.database;
    final maps = await db!.query(
      userTable,
      columns: UserFields.allFields,
      where: "${UserFields.username} = ?",
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception("$username not Found");
    }
  }

  Future<List<User>> getAllUser(String username) async {
    final db = await instance.database;
    final results =
        await db!.query(userTable, orderBy: "${UserFields.username} ASC");

    return results.map((e) => User.fromJson(e)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;

    return db!.update(
      userTable,
      user.toJson(),
      where: "${UserFields.username} = ?",
      whereArgs: [user.username],
    );
  }

  Future<int> deleteUser(String username) async {
    final db = await instance.database;

    return db!.delete(
      userTable,
      where: "${UserFields.username} = ?",
      whereArgs: [username],
    );
  }

  Future<Reflection> createReflction(Reflection reflection) async {
    final db = await instance.database;

    await db!.insert(reflectionTable, reflection.toJson());
    return reflection;
  }

  Future<List<Reflection>> getAllReflections(String username) async {
    final db = await instance.database;
    final results = await db!.query(reflectionTable,
        orderBy: "${ReflectionFields.created} DESC",
        where: "${ReflectionFields.username} = ?",
        whereArgs: [username]);

    return results.map((e) => Reflection.fromJson(e)).toList();
  }

  Future<int> deleteReflection(Reflection reflection) async {
    final db = await instance.database;

    return db!.delete(
      reflectionTable,
      where:
          "${ReflectionFields.title} = ? AND ${ReflectionFields.username} = ?",
      whereArgs: [reflection.title, reflection.username],
    );
  }
}
