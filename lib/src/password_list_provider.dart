import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserData {
  var password;

  var title;

  var username;
  var passwordType;

  UserData(
      {required this.title,
      required this.username,
      required this.password,
      required this.passwordType});
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
    showNotification(password);
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

void showNotification(String password) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    "my_app_id",
    "my_name",
    "its a notification for adding password",
    importance: Importance.max,
    // priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await FlutterLocalNotificationsPlugin().show(0, "New Password",
      "A new password was added $password", platformChannelSpecifics);
}
