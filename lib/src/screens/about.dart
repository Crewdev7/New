import 'package:flutter/material.dart';
import 'package:password_manager/src/globals.dart';
import 'package:password_manager/src/utils/mix.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      // appBar: AppBar(
      //   title: const Text("About"),
      // ),
      appBarTitle: "About",
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
                      appName,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      description,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Author: $author",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          "Version: $version",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
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
                    leading: const Icon(Icons.update),
                    title: const Text("Check for update"),
                    subtitle: const Text("A new version is available"),
                    trailing: const Icon(Icons.front_loader),
                    onTap: () {
                      print("checking for update");
                    },
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
                    leading: const Icon(Icons.web),
                    title: const Text("Webiste"),
                    subtitle: const Text("http://www.example.com"),
                    trailing: const Icon(Icons.open_in_browser),
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
                    leading: const Icon(Icons.code),
                    title: const Text("Source Code"),
                    trailing: const Icon(Icons.open_in_new),
                    subtitle: const Text("http://www.github.com"),
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
                    leading: const Icon(Icons.support),
                    title: const Text("Donate"),
                    trailing: const Icon(Icons.menu_open),
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
                    subtitle: const Text("Capture logs"),
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
