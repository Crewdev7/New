import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../globals.dart';

class DataListProvider extends ChangeNotifier {
  List<PasswordData1> _passwords = [];

  final _databaseHelper = DatabaseHelper();
  final tableName = DatabaseHelper.tableName;
  List<PasswordData1> get password {
    return _passwords;
  }

  set password(val) {
    _passwords = val;
  }

  Future<int> add(PasswordData userData) async {
    return await DatabaseHelper.insertEntry(tableName, userData).then((id) {
      notifyListeners();
      return id;
    }).onError((error, stackTrace) {});
  }

  Future<bool> remove(int id) async {
    await DatabaseHelper.deleteEntry(id);
    notifyListeners();
    return true;
  }

  Future<bool> getEntries() async {
    final entries = await DatabaseHelper.getEntries();
    _passwords.clear();
    _passwords.addAll(
        entries.map((json) => PasswordData1.fromJsonMap(json)).toList());
    var s = password.forEach((element) {
      writeToLogFile("etries we getentries: $entries");
      print("${element.toJsonMap().toString()}");
    });
    return true;
  }

  Future<PasswordData1?> getEtry(int id) async {
    final entry = await _databaseHelper.getEntry(id);
    return entry!;
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;
  static String get tableName => "mylist";

  DatabaseHelper.internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    initDatabase;
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    // final secondPath = await getApplicationSupportDirectory();
    final path = join(databasesPath, "ok.db");

    return _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
              CREATE TABLE IF NOT EXISTS $tableName(
              id INTEGER PRIMARY KEY,
              title TEXT,
              username TEXT,
              password TEXT,
              passwordLength TEXT,
              passwordType TEXT,
              createdAt INTEGER)
            ''');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await DatabaseHelper.initDatabase();
    return await db.query(tableName);
  }

  static Future insertEntry(String table, PasswordData data) async {
    final db = await DatabaseHelper.initDatabase();
    return await db.insert(table, data.toMap());
  }

  static Future<int> deleteEntry(int id) async {
    final db = await DatabaseHelper.initDatabase();
    return await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<PasswordData1?> getEntry(int id) async {
    final db = await DatabaseHelper.initDatabase();
    final result =
        await db.query(tableName, where: "id = ?", whereArgs: [id], limit: 1);
    print("we get result: $result");

    if (result.isNotEmpty) {
      final result2 = PasswordData1.fromJsonMap(result.first);
      print("web get result2=$result2");
      // return result.map((json) PasswordData1
      // .fromJsonMap(json));
    } else {
      return null;
    }
  }
}

class PasswordData1 {
  final String password;
  final String title;
  final String username;
  final String passwordType;
  final DateTime createdAt;
  final String passwordLength;
  final int? id;

  PasswordData1({
    required this.title,
    required this.username,
    required this.password,
    required this.passwordType,
    required this.createdAt,
    required this.passwordLength,
    this.id,
  });

  T toEnumValue<T>(String data, {required List<T> values}) {
    return values.firstWhere((T value) => describeEnum(value!) == data,
        orElse: () => values.firstWhere(
              (T value) => describeEnum(value!) == "unknown",
            ));
  }

  List<T> toEnumValueList<T>(
    List<String> dataList, {
    required List<T> values,
  }) {
    return dataList
        .map(
          (String data) => toEnumValue(data, values: values),
        )
        .toList();
  }

  PasswordData1.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        title = map['title'] as String,
        password = map['password'] as String,
        username = map['username'] as String,
        passwordType = describeEnum(map['passwordType']),
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        passwordLength = map['passwordLength'] as String;

// convert input into this
  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'passwordType': passwordType,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'passwordTypeIcon': toEnumValue(
        passwordType,
        values: PasswordType.values,
      ),
      'passwordLength': passwordLength
    };
  }
}
