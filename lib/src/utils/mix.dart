import 'package:flutter/material.dart';
import 'package:password_manager/src/dark_theme_provider.dart';
import 'package:provider/provider.dart';

import '../dashboard_screen.dart';

getIconForType(PasswordType type) {
  switch (type) {
    case PasswordType.email:
      return const Icon(Icons.email);
    case PasswordType.ios:
      return const Icon(Icons.iso);
    case PasswordType.android:
      return const Icon(Icons.android);

    case PasswordType.username:
      return const Icon(Icons.verified_user);
    case PasswordType.website:
      return const Icon(Icons.web_sharp);
    default:
      return const Icon(Icons.verified_user_sharp);
  }
}

class MyScaffold extends StatelessWidget {
  final appBarActions;
  final onDarkModeToggle;
  final appBarTitle;
  final body;
  MyScaffold({
    super.key,
    required this.body,
    this.appBarTitle,
    this.onDarkModeToggle,
    this.appBarActions,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> mergedActions = [];

    if (onDarkModeToggle == null) {
      mergedActions.add(IconButton(
          onPressed: () {
            final darkModeProvider =
                Provider.of<DarkThemeProvider>(context, listen: false);
            darkModeProvider.toggle();
          },
          icon: const Icon(Icons.brightness_6)));
    }
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle != null ? Text(appBarTitle) : null,
        actions: mergedActions.isNotEmpty ? mergedActions : null,
      ),
      body: body,
    );
  }
}
