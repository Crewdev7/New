import 'package:flutter/foundation.dart';
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
      final pref = await SharedPreferences.getInstance();
      _isDarkMode = pref.getBool("darkTheme") ?? false;
      notifyListeners();
      return true;
    } catch (e) {
      return true;
    }
  }
}
