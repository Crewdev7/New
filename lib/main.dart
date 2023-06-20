import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/dark_theme_style.dart';
import 'package:password_manager/src/dashboard_screen.dart';
import 'package:password_manager/src/setting_screen.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:io';

import 'src/dark_theme_provider.dart';
import 'src/home_screen.dart';
import 'src/password_list_provider.dart';

const double windowWidth = 480;
const double windowHeight = 854;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle("Provider counter");
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => DarkThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => UserInputData(),
      ),
      ChangeNotifierProvider(
        create: (context) => PasswordListProvider(),
      ),
    ],
    child: PasswordManagerApp(),
  ));

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings("@mipmap/ic_launcher");
  // final InitializationSettings initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class PasswordManagerApp extends StatelessWidget {
  const PasswordManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<DarkThemeProvider>(context);
    themeData.loadTheme();
    return FocusScope(
      child: MaterialApp(
        theme: Styles.themeData(themeData.isDark, context),
        title: "Password Manager",
        initialRoute: '/',
        routes: {
          "/": (context) => const HomeScreen(),
          "settings": (context) => const SettingScrenn(),
        },
      ),
    );
  }
}
