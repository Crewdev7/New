import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDark => _isDarkMode;

  void toggle() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    print("Theme is toggled");
    final pref = await SharedPreferences.getInstance();
    await pref.setBool("darkTheme", isDark);
  }

  Future<bool> get loadTheme async {
    print("Load theme is called");
    final pref = await SharedPreferences.getInstance();
    var isDark = pref.getBool("darkTheme");
    _isDarkMode = isDark!;

    print("Load theme is called");
    return true;
  }
}
