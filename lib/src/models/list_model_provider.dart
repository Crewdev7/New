import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../globals.dart';

class DataListProvider extends ChangeNotifier {
  List<PasswordData1> _passwords = [];

  final _databaseHelper = DatabaseHelper();
  List<PasswordData1> get password {
    return _passwords;
  }

  set password(val) {
    _passwords = val;
  }

  Future<int> add(PasswordData userData) async {
    return await _databaseHelper.insertEntry(userData).then((id) {
      notifyListeners();
      return id;
    });
  }

  Future<bool> get getEntries async {
    final entries = await _databaseHelper.getEntries();
    _passwords.clear();
    _passwords.addAll(
        entries.map((json) => PasswordData1.fromJsonMap(json)).toList());
    var s = password.forEach((element) {
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
  static String? _tabelName;

  String get tabelname {
    if (_tabelName != null) {
      return _tabelName!;
    }
    tabelname = "defaultpass";
    // maybe can  remove but had issue  if so
    // ignore: recursive_getters
    return tabelname;
  }

  set tabelname(String val) {
    _tabelName = val;
  }

  DatabaseHelper.internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase;
    return _database!;
  }

  Future<Database> get initDatabase async {
    final databasesPath = await getDatabasesPath();
    if (!await Directory(databasesPath).exists()) {
      await Directory(databasesPath).create(recursive: true);
    }
    final path = join(databasesPath, "oeoooeoooo.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
              CREATE TABLE IF NOT EXISTS $tabelname(
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

  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await database;
    return db.query(tabelname);
  }

  Future<int> insertEntry(PasswordData data) async {
    final db = await database;
    return await db.insert(tabelname, data.toMap());
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete(tabelname, where: "id = ?", whereArgs: [id]);
  }

  Future<PasswordData1?> getEntry(int id) async {
    final db = await database;
    final result = await db.query(tabelname, where: "id = ?", whereArgs: [id]);

    if (result.isNotEmpty) {
      result.map((json) => PasswordData1.fromJsonMap(json)).toList();
    } else {
      return null;
    }
    return null;
  }
}

class PasswordData1 {
  final String password;
  final String title;
  final String username;
  // Change it to  passwordType
  final String passwordType;
  // final PasswordType passwordType;
  final DateTime createdAt;
  final String passwordLength;
  final int? id;
  PasswordType? passwordTypeIcon;
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
        passwordType = describeEnum(map['passwordType']) as String,
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        passwordLength = map['passwordLength'] as String;

// convert input into this
  Map<String, dynamic> toJsonMap() {
    print("my data is:$this");
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
      ) as PasswordType,
      'passwordLength': passwordLength
    };
  }
}

class Dog {
  final int id;
  final String name;
  final int age;
  const Dog({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return "Dog{id:$id,name:$name,age:$age}";
  }
}
