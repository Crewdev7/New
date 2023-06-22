import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../globals.dart';

class Sources extends ChangeNotifier {
  int _passwordLimit = 8;
  bool uppercase = true;
  bool lowercase = true;
  bool number = true;
  bool special = true;
  bool custom = false;

  final letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final numbers = 1234567890;
  final specialChars = "~`!@#\$%^&*(){}/?+=-_|\\::\"";
  String? customChars;
  // methods
  //    getters
  int get getPasswordLimit => _passwordLimit;

  String source = "";

  void getSource() {
    if (uppercase) {
      source += letters;
    }
    if (lowercase) {
      source += letters.toLowerCase();
    }
    if (number) {
      source += numbers.toString();
    }
    if (special) {
      source += specialChars;
    }
    if (custom && customChars != null) {
      source += customChars!;
    }
    notifyListeners();
  }

  isChecked(field) {
    if (field == "uppercase") {
      return uppercase;
    }
    if (field == "lowercase") {
      return lowercase;
    }
    if (field == "special") {
      return special;
    }
    if (field == "number") {
      return number;
    }
    if (field == "custom") {
      return custom;
    }
    return false;
  }

  bool toggleSource(String keyname, bool val) {
    var isTrue;
    switch (keyname) {
      case "uppercase":
        isTrue = uppercase = val;
        break;
      case "lowercase":
        isTrue = lowercase = val;
        break;
      case "number":
        isTrue = number = val;
        break;
      case "special":
        isTrue = special = val;
        break;
      case "custom":
        isTrue = custom = val;
        break;
      default:
        isTrue = false;
        break;
    }

    notifyListeners();

    setPrefs(key: keyname, value: val, isBool: true)
        .then((value) => print("Prefs.  set succefuly"))
        .catchError((e) => print("Unable  to set Prefs.$e"));
    return isTrue;
  }

  set setPasswordLimit(int value) {
    _passwordLimit = value;
    notifyListeners();
  }

  Future<void> initPref(keyname) async {
    final prefs = await SharedPreferences.getInstance();
    keyname = prefs.getBool(keyname)!;
    notifyListeners();
  }

  Future<void> setPrefs(
      {String key = "",
      value,
      bool isBool = false,
      bool isInt = false,
      bool isStr = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (isBool) {
        await prefs.setBool(key, value);
      }
      if (isInt) {
        await prefs.setInt(key, value);
      }
      if (isStr) {
        await prefs.setString(key, value);
      }
    } catch (e) {
      throw Error.safeToString(e);
    }
    ;
  }
}

class InputDataProvider extends ChangeNotifier {
  PasswordType _passwordType = PasswordType.username;

  String _title = "";
  String _username = "";
  String _password = "";
  int _passwordLength = 0;
  int _usernameLength = 0;

  int get getPasswordLength => _passwordLength;
  int get getUsernameLength => _usernameLength;
  String get getTitle => _title;
  String get getUsername => _username;
  String get getPassword => _password;

  PasswordType get getPasswordType => _passwordType;

  String get getFieldName {
    var pass = getPasswordType.toString().split('.').last;
    return pass[0].toUpperCase() + pass.substring(1);
  }

  void generatedPassword(String source, int limit) {
    for (var i = 0; i < limit; i++) {
      var rand = Random();
      _password += source[rand.nextInt(source.length)];
    }
    setPassword = _password;
    setPassLength = getPasswordLength;
  }

  set setPasswordType(PasswordType v) {
    _passwordType = v;
    notifyListeners();
  }

  set setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  set setPassword(String value) {
    _password = value;
    _passwordLength = value.length;
    notifyListeners();
  }

  set setUsername(String value) {
    _username = value;
    _usernameLength = value.length;
    notifyListeners();
  }

  set setPassLength(int value) {
    _passwordLength = value;
    notifyListeners();
  }

  void resetFields({user = true, pass = true, title = true}) {
    if (user) {
      setUsername = user;
    }
    if (pass) {
      setPassword = pass;
    }
    if (title) {
      setTitle = title;
    }
    notifyListeners();
  }

  PasswordData get getInputData {
    return PasswordData(
        title: getTitle,
        username: getUsername,
        password: getPassword,
        passwordType: getPasswordType,
        createdAt: DateTime.now(),
        passwordLength: getPasswordLength);
  }
}
