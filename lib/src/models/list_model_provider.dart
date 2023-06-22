import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

class DataListProvider extends ChangeNotifier {
  final List<PasswordData> _passwords = [];

  void addEntry(PasswordData userData) {
    _passwords.add(userData);
    notifyListeners();
  }

  List<PasswordData> get getLists {
    return _passwords;
  }
}
