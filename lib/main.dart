import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/globals.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'package:async/async.dart';

import 'dart:io';

import 'src/models/add_model_provider.dart';
import 'src/models/app_model_provider.dart';
import 'src/models/list_model_provider.dart';
import 'src/models/theme_provider.dart';
import 'src/screens/init.dart';
import 'src/screens/setting.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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

Future main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
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
      ChangeNotifierProvider(
        create: (context) => Sources(),
      ),
    ],
    child: PasswordManagerApp(),
  ));
}

class PasswordManagerApp extends StatefulWidget {
  const PasswordManagerApp({super.key});

  @override
  State<PasswordManagerApp> createState() => _PasswordManagerAppState();
}

class _PasswordManagerAppState extends State<PasswordManagerApp> {
  AppProvider appState = new AppProvider();

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<AppProvider>(context);

    // var settingz = context.read<Sources>();
    // settingz.().then(
    //   (value) {
    //     print("successfully called init");
    //   },
    // ).onError((error, stackTrace) {
    //   print("you got error while initialization of init error:$error");
    //   // print("Stacktrace is::$stackTrace");
    // });
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
