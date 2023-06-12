import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PasswordListProvider extends ChangeNotifier {
  List<String> passwords = [];

  void addPassword(String password) {
    passwords.add(password);
    showNotification(password);
    notifyListeners();
  }

  void removePassword(String password) {
    passwords.remove(password);
    showNotification(password);
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
