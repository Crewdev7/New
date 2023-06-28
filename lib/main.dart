import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/globals.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_size/window_size.dart';

import 'dart:io';

import 'src/models/add_model_provider.dart';
import 'src/models/app_model_provider.dart';
import 'src/models/list_model_provider.dart';
import 'src/models/theme_provider.dart';
import 'src/screens/init.dart';
import 'src/screens/setting.dart';

const double windowWidth = 720;
const double windowHeight = 1100;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle("Passy Manager");
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
    writeToLogFile("Linux is runnnig");
  }
}

Future<bool> loadTheme2() async {
  final pref = await SharedPreferences.getInstance();
  // reads from system if not set
  return pref.getBool("darkTheme") ?? false;
}

Future<void> main() async {
  // init themes and pass  to provider for now
  print("main is loaded");
  writeToLogFile("main is loaded");
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = AppProvider();
  var isDark = await themeProvider.loadTheme;
  print("dark theem provider is loaded");
  writeToLogFile("dark theem provider is loaded");

  // setupWindow();

  final sourceProvider = Sources();
  final ok = await sourceProvider.initPref();
  print("thiis is in main  for sourcesprovider initpref call");
  writeToLogFile("thiis is in main  for sourcesprovider initpref call");
  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(
      //   create: (context) => AppProvider(),
      // ),
      ChangeNotifierProvider.value(
        value: themeProvider,
      ),
      ChangeNotifierProvider(
        create: (context) => InputDataProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => DataListProvider(),
      ),
      ChangeNotifierProvider.value(
        value: sourceProvider,
      ),
    ],
    child: const PasswordManagerApp(),
  ));
}

class PasswordManagerApp extends StatefulWidget {
  const PasswordManagerApp({super.key});

  @override
  State<PasswordManagerApp> createState() => _PasswordManagerAppState();
}

class _PasswordManagerAppState extends State<PasswordManagerApp> {
  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<AppProvider>(context, listen: true);
    print("PasswordManagerApp is loadod");
    writeToLogFile("PasswordManagerApp is loadod");

    return FocusScope(
      child: MaterialApp(
        // theme Provider
        theme: Styles.themeData(themeData.isDark, context),
        title: appTitle,
        initialRoute: '/',
        routes: {
          "/": (context) => const InitScreen(),
          "settings": (context) => const SettingScreen(),
        },
      ),
    );
  }
}
