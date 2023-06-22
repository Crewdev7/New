
import 'package:flutter/material.dart';

class SettingScrenn extends StatelessWidget {
  const SettingScrenn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(children: const [
        ListTile(
          title: Text("Enable dark  mode"),
        ),
        ListTile(
          title: Text("Backup and restore"),
        ),
        ListTile(
          title: Text("About"),
        )
      ]),
    );
  }
}
