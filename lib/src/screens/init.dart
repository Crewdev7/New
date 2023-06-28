import 'package:flutter/material.dart';
import 'package:password_manager/src/screens/about.dart';
import 'package:password_manager/src/screens/add.dart';
import 'package:password_manager/src/screens/list.dart';
import 'package:password_manager/src/screens/setting.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});
  static const routeName="/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

List<Widget> screens = [
  const AddScreen(),
  const DataListScreen(),
  const SettingScreen(),
  const AboutScreen(),
];

class _InitScreenState extends State<InitScreen> {
  int currentIndex = 0;
  var isok = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
