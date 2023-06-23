import 'package:flutter/material.dart';
import 'package:password_manager/src/models/app_model_provider.dart';
import 'package:provider/provider.dart';

class MyScaffold extends StatelessWidget {
  final appBarActions;
  final onDarkModeToggle;
  String? appBarTitle;
  final Widget body;
  final Widget? floatingActionButton;
  MyScaffold({
    super.key,
    required this.body,
    this.appBarTitle,
    this.onDarkModeToggle,
    this.appBarActions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> mergedActions = [];

    if (onDarkModeToggle == null) {
      mergedActions.add(IconButton(
          onPressed: () {
            final appState = Provider.of<AppProvider>(context, listen: false);
            appState.toggle();
          },
          icon: const Icon(Icons.brightness_6)));
    }
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle != null ? Text(appBarTitle!) : null,
        actions: mergedActions.isNotEmpty ? mergedActions : null,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
