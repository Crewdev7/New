import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Password Manager",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "A secure password managment app",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Author: CrewD",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Card(
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text("Source Code"),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1.0,
            ),
            Card(
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.bug_report),
                    title: const Text("Report an Issue"),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
