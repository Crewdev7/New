import 'package:flutter/material.dart';
import 'package:password_manager/src/about_screen.dart';
import 'package:password_manager/src/dashboard_screen.dart';
import 'package:password_manager/src/password_list_screen.dart';
import 'package:password_manager/src/setting_screen.dart';
import 'package:provider/provider.dart';

import 'dark_theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<Widget> screens = [
  const DashboardScreen(),
  const PasswordListScreen(),
  const SettingScrenn(),
  const AboutScreen(),
];

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var darkMode = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //     leading: IconButton(
      //         onPressed: () {
      //           darkMode.toggle();
      //         },
      //         icon: const Icon(Icons.dark_mode))),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home_filled),
              label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              activeIcon: Icon(Icons.list_alt_outlined),
              label: "Entries"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              activeIcon: Icon(Icons.settings),
              label: "Settings"),
          BottomNavigationBarItem(
              icon: Icon(Icons.info),
              activeIcon: Icon(Icons.info_sharp),
              label: "About"),
        ],
      ),
    );
  }
}
