import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../globals.dart';

class Sources extends ChangeNotifier {
  // Public field no need to  encapsulate
  bool uppercase = true;
  bool lowercase = true;
  bool number = true;
  bool special = true;
  bool _custom = true;

  bool get custom {
    return _custom;
  }

  set custom(bool value) {
    _custom = value;
    notifyListeners();
  }

  final letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final numbers = 1234567890;
  final specialChars = "~`!@#\$%^&*(){}/?+=-_|\\::\"";
  String _customChars = "";

  String get customChars {
    return _customChars;
  }

  set customChars(String value) {
    _customChars = value;
    addCustomChars();
    notifyListeners();
  }

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
    // notifyListeners();
  }

  void addCustomChars() {
    setPrefs(
            key: describeEnum(SourceFieldType.customChars),
            value: customChars,
            isStr: true)
        .then((value) =>
            // ignore: avoid_print
            print("Prefs.  set succefuly for custom chars#$customChars"))
        // ignore: avoid_print
        .catchError((e) => print("Unable  to set pref for custom char.$e"));
  }

  void toggleSource(String keyname, bool val) {
    switch (keyname) {
      case "uppercase":
        uppercase = val;
        break;
      case "lowercase":
        lowercase = val;
        break;
      case "number":
        number = val;
        break;
      case "special":
        special = val;
        break;
      case "custom":
        custom = val;
        break;
      default:
        break;
    }

    notifyListeners();

    setPrefs(key: keyname, value: val, isBool: true)
        // ignore: avoid_print
        .then((value) => print("Prefs.  set succefuly for bool"))
        // ignore: avoid_print
        .catchError((e) => print("Unable  to set Prefs.$e"));
  }

  set setPasswordLimit(int value) {
    _passwordLimit = value;
    setPrefs(
            key: describeEnum(SourceFieldType.passwordLimit),
            value: value,
            isInt: true)
        .then((success) {
      writeToLogFile("password limit set success with value $value");
    }).onError((error, stackTrace) {
      writeToLogFile("Error while setting password limit");
    });

    notifyListeners();
  }

  Future<bool> initPref() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      uppercase =
          prefs.getBool(describeEnum(SourceFieldType.uppercase)) ?? true;
      lowercase =
          prefs.getBool(describeEnum(SourceFieldType.lowercase)) ?? true;
      number = prefs.getBool(describeEnum(SourceFieldType.number)) ?? true;
      special = prefs.getBool(describeEnum(SourceFieldType.special)) ?? true;
      custom = prefs.getBool(describeEnum(SourceFieldType.custom)) ?? false;
      _passwordLimit =
          prefs.getInt(describeEnum(SourceFieldType.passwordLimit)) ?? 8;
      customChars =
          prefs.getString(describeEnum(SourceFieldType.customChars)) ?? "";
      // customChars="";
      notifyListeners();
      return true;
    } catch (e) {
      writeToLogFile("error initPref :$e");
      return false;
    }
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
      writeToLogFile("error setPrefs: $e");
    }
  }
}

class InputDataProvider extends ChangeNotifier {
  PasswordType _passwordType = PasswordType.username;
  PasswordType get passwordType => _passwordType;

  set passwordType(PasswordType value) {
    _passwordType = value;
    notifyListeners();
  }

  String _title = "";
  String get title => _title;

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String _username = "";
  String get username => _username;

  set username(String value) {
    _username = value;
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

  String get getFieldName {
    var pass = passwordType.toString().split('.').last;
    return pass[0].toUpperCase() + pass.substring(1);
  }

  void generatePassword(String source, int limit) {
    password = "";
    for (var i = 0; i < limit; i++) {
      final rand = Random();
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
