import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../globals.dart';
import '../screens/add.dart';

class Sources extends ChangeNotifier {
  // Public field no need to  encapsulate
  bool uppercase = true;
  bool lowercase = true;
  bool number = true;
  bool special = true;
  bool custom = true;

  final letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final numbers = 1234567890;
  final specialChars = "~`!@#\$%^&*(){}/?+=-_|\\::\"";
  String customChars = "23t";

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

  void addCustomChars(String keyname, String val) {
    setPrefs(key: keyname, value: val, isStr: true)
        .then((value) =>
            print("Prefs.  set succefuly for custom chars#$customChars"))
        .catchError((e) => print("Unable  to set pref for custom char.$e"));
  }

  void toggleSource(String keyname, bool val) {
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
        .then((value) => print("Prefs.  set succefuly for bool"))
        .catchError((e) => print("Unable  to set Prefs.$e"));
  }

  set setPasswordLimit(int value) {
    _passwordLimit = value;
    setPrefs(
            key: describeEnum(CheckboxField.passwordLimit),
            value: value,
            isInt: true)
        .then((success) {
      print("password limit set success with value $value");
      writeToLogFile("password limit set success with value $value");
    }).onError((error, stackTrace) {
      print("Error while setting password limit");
      writeToLogFile("Error while setting password limit");
    });

    notifyListeners();
  }

  Future<bool> initPref() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var ok = prefs.getKeys();
      print("initPref inside#$ok");
      uppercase = prefs.getBool(describeEnum(CheckboxField.uppercase)) as bool;
      lowercase = prefs.getBool(describeEnum(CheckboxField.lowercase)) as bool;
      number = prefs.getBool(describeEnum(CheckboxField.number)) as bool;
      special = prefs.getBool(describeEnum(CheckboxField.special)) as bool;
      custom = prefs.getBool(describeEnum(CheckboxField.custom)) as bool;
      _passwordLimit =
          prefs.getInt(describeEnum(CheckboxField.passwordLimit)) ?? 8;
      customChars =
          prefs.getString(describeEnum(CheckboxField.customChars)) ?? "";
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
      print("setPrefs inside error : $e");
      writeToLogFile("error setPrefs: $e");
    }
  }
}

class InputDataProvider extends ChangeNotifier {
  PasswordType _passwordType = PasswordType.username;
  PasswordType get passwordType => _passwordType;

  void spasswordType(PasswordType value) {
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
