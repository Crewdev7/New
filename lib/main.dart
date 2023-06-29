import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/globals.dart';
import 'package:provider/provider.dart';
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
  }
}

Future<void> main() async {
  // MultiPlatform checker
  setupWindow();
  // init themes and pass  to provider for now
  // State object creation
  final themeProvider = AppProvider();
  final sourceProvider = Sources();

  WidgetsFlutterBinding.ensureInitialized();

// States inits
  await themeProvider.loadTheme;
  await sourceProvider.initPref();

  runApp(MultiProvider(
    providers: [
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
    return MaterialApp(
      // theme Provider
      theme: Styles.themeData(
          context.select((AppProvider p) => p.isDark), context),
      title: appTitle,
      initialRoute: '/',
      routes: {
        InitScreen.routeName: (context) => const InitScreen(),
        SettingScreen.routeName: (context) => const SettingScreen(),
      },
    );
  }
}
