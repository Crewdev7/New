import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/dashboard_screen.dart';

class UserData {
  String password;
  String title;
  String username;
  PasswordType passwordType;
  DateTime createdAt;
  int passwordLength;

  UserData({
    required this.title,
    required this.username,
    required this.password,
    required this.passwordType,
    required this.createdAt,
    required this.passwordLength,
  });
}

class PasswordListProvider extends ChangeNotifier {
  List<UserData> passwords = [];
  bool isDarkMode = true;

  void addPassword(String password) {
    notifyListeners();
  }

  void addEntry(UserData userData) {
    passwords.add(userData);
    notifyListeners();
  }

  void removePassword(String password) {
    // showNotification(password);
    notifyListeners();
  }

  // void filterPasswords(String query) {
  //   passwords =
  //       passwords.where((pass) => pass.toLowerCase().contains(query)).toList();
  //   notifyListeners();
  // }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
//
// void showNotification(String password) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     "my_app_id",
//     "my_name",
//     "its a notification for adding password",
//     importance: Importance.max,
//     // priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await FlutterLocalNotificationsPlugin().show(0, "New Password",
//       "A new password was added $password", platformChannelSpecifics);
// }
