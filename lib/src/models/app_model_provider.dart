import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDark => _isDarkMode;

  AppProvider(this._isDarkMode);

  void toggle() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    await pref.setBool("darkTheme", isDark);
  }

  Future<void> loadTheme() async {
    final pref = await SharedPreferences.getInstance();
    var isDark = pref.getBool("darkTheme");
    _isDarkMode = isDark!;
    notifyListeners();
  }
}
