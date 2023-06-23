import 'package:flutter/material.dart';
import 'package:password_manager/src/models/add_model_provider.dart';
import 'package:password_manager/src/models/app_model_provider.dart';
import 'package:password_manager/src/utils/mix.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customCharController = TextEditingController();
    // using watch works in such a way that we dont have to  wrap all of these in any consumber
    // if you change value from any where its value will we reflected here too
    var isDark = context.watch<AppProvider>();
    var source = context.watch<Sources>();
    customCharController.text = source.customChars;
    customCharController.selection = TextSelection.fromPosition(
        TextPosition(offset: customCharController.text.length));

    return MyScaffold(
      appBarTitle: "Settings",
      body: Builder(builder: (context) {
        return ListView(children: [
          SwitchListTile(
              value: isDark.isDark,
              title: const Text("Enable Darkmode"),
              onChanged: (v) {
                isDark.toggle();
              }),
          SwitchListTile(
              value: source.custom,
              title: const Text("Enable Custom letters"),
              onChanged: (v) {
                source.toggleSource('custom', v);
              }),
          source.custom
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 30),
                  child: TextField(
                    maxLines: 5,
                    minLines: 1,
                    controller: customCharController,
                    onChanged: (value) {
                      source.customChars = value;
                    },
                    decoration: const InputDecoration(
                        label: Text("Custom charaters/letters")),
                  ),
                )
              : const Divider(),
          const ListTile(
            title: Text("Backup and restore"),
          ),
          const ListTile(
            title: Text("About"),
          )
        ]);
      }),
      //   body:
      //       SwitchListTile(
      //           value: isDark.isDark,
      //           title: Text("Enable Darkmode"),
      //           onChanged: (v) {
      //             isDark.toggle();
      //           }),
    );
  }
}
