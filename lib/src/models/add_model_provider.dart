import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../globals.dart';
// BUGS
///// when a type somethitg on any text input fields then checkbox state also renders
///// te test add print call in checkbox widget and chekc for on chonge value in onchange function

class Sources extends ChangeNotifier {
  // Public field no need to  encapsulate
  bool uppercase = true;
  bool lowercase = true;
  bool number = true;
  bool special = true;
  bool custom = false;

  final letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final numbers = 1234567890;
  final specialChars = "~`!@#\$%^&*(){}/?+=-_|\\::\"";
  String customChars = "";

  int _passwordLimit = 8;
  int get getPasswordLimit => _passwordLimit;

  String source = "";

  void getSource() {
    source = "";
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
    if (custom && customChars.isNotEmpty) {
      source += customChars.replaceAll(" ", "");
    }
    if (kDebugMode) {
      print("getSource in add model Rendered again is this normal::::??");
      print("password sources are: $source");
    }
    notifyListeners();
  }

  bool isChecked(field) {
    if (kDebugMode) {
      print("IsChekched from add model Rendered again is this normal::::??");
      print("ischecked recive: f$field");
    }
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
    bool isTrue;
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
  }
}

class InputDataProvider extends ChangeNotifier {
  PasswordType _passwordType = PasswordType.username;

  PasswordType get passwordType => _passwordType;
  void spasswordType(PasswordType value) {
    _passwordType = value;
  }

  String _title = "";
  String get title => _title;
  set title(String value) {
    _title = value;

  }

  String _username = "";
  String get username => _username;
  set username(String value) {
    _username = value;
    usernameLength = value.length;
    notifyListeners();
  }

  String _password = "";
  String get password => _password;
  set password(String value) {
    _password = "";
    _password = value;
    passwordLength = _password.length;
    notifyListeners();
  }

  int _passwordLength = 0;
  int get passwordLength => _passwordLength;
  set passwordLength(int value) {
    _passwordLength = value;
    notifyListeners();
  }

  int _usernameLength = 0;
  int get usernameLength => _usernameLength;
  set usernameLength(int value) {
    _usernameLength = value;
    notifyListeners();
  }

  String get getFieldName {
    var pass = passwordType.toString().split('.').last;
    return pass[0].toUpperCase() + pass.substring(1);
  }

  void generatedPassword(String source, int limit) {
    password = "";
    for (var i = 0; i < limit; i++) {
      var rand = Random();
      password += source[rand.nextInt(source.length)];
    }
    passwordLength = password.length;
    notifyListeners();
  }

  void resetFields({user = true, pass = true, title1 = true}) {
    if (user) {
      username = "";
    }
    if (pass) {
      password = "";
    }
    if (title1) {
      title = "";
    }
    notifyListeners();
  }

  PasswordData get getInputData {
    return PasswordData(
      title: title,
      username: username,
      password: password,
      passwordType: passwordType,
      createdAt: DateTime.now(),
      passwordLength: passwordLength,
    );
  }
}
