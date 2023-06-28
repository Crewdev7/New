import 'package:flutter/foundation.dart';
import 'package:password_manager/src/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDark => _isDarkMode;

  void toggle() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    await pref.setBool("darkTheme", isDark);
  }

  Future<bool> get loadTheme async {
    try {
      print("Load theme is called");
      final pref = await SharedPreferences.getInstance();
      _isDarkMode = pref.getBool("darkTheme") ?? false;

      notifyListeners();
      return true;
    } catch (e) {
      print("loadTheme errored:$e");
      writeToLogFile("loadTheme errored:$e");
      return true;
    }
  }
}
