import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/globals.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:io';

import 'src/models/add_model_provider.dart';
import 'src/models/app_model_provider.dart';
import 'src/models/list_model_provider.dart';
import 'src/models/theme_provider.dart';

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
        create: (context) => AppProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => InputDataProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => DataListProvider(),
      ),
    ],
    child: const PasswordManagerApp(),
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
    var themeData = Provider.of<AppProvider>(context);
    themeData.loadTheme();

    return FocusScope(
      child: MaterialApp(
        // theme Provider
        theme: Styles.themeData(themeData.isDark, context),
        title: appTitle,
        initialRoute: '/',
        routes: {
          "/": (context) => const InitScreen(),
          "settings": (context) => const SettingScrenn(),
        },
      ),
    );
  }
}
