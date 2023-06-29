import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/models/add_model_provider.dart';
import 'package:password_manager/src/models/app_model_provider.dart';
import 'package:password_manager/src/screens/about.dart';
import 'package:password_manager/src/utils/mix.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../widgets/c_chars_dialog.dart';

// TODO can be extracted into its own widgets
// to keep changes easy in future
// each widgets not depends on parents
// get state from provider instead
void charsOnChange(BuildContext context, v) {
  //only toggle if charaters not empty
  // show showDialog if empty
  // toggle if charaters are present
  if (!context.read<Sources>().custom &&
      context.read<Sources>().customChars.isEmpty) {
    showDialog(
      context: context,
      builder: (context) => const CustomCharsDialog(),
    );
    return;
  }
  context.read<Sources>().toggleSource(describeEnum(SourceFieldType.custom), v);
}

class SettingScreen extends StatelessWidget {
  static String routeName = "/Settings";
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // using watch works in such a way that we dont have to  wrap all of these in any consumber
    // if you change value from any where its value will we reflected here too
    final sourceRead = context.read<Sources>();

    return MyScaffold(
      appBarTitle: "Settings",
      body: Builder(builder: (context) {
        var charsToggle = SwitchListTile(
            // value: context.select((Sources p) => p.custom),
            value: context.watch<Sources>().custom,
            title: const Text("Enable Custom letters"),
            onChanged: (v) => charsOnChange(context, v));

        var customCharsList = Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.watch<Sources>().customChars),
              ButtonBar(
                children: [
                  context.watch<Sources>().customChars.isNotEmpty
                      ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                sourceRead.customChars = "";
                                sourceRead.custom = false;
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const CustomCharsDialog(),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            )
                          ],
                        )
                      : const SizedBox(),
                ],
              )
            ],
          ),
        );
        final darkThemeSwitch = SwitchListTile(
            value: context.watch<AppProvider>().isDark,
            title: const Text("Enable Darkmode"),
            onChanged: (v) {
              context.read<AppProvider>().toggle();
            });

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // Theme switch
              darkThemeSwitch,

              // Custom charaters toggler
              charsToggle,

              // Cusotm charaters
              customCharsList,
              const ListTile(
                title: Text("Backup and restore"),
              ),
              //About page
              ListTile(
                title: const Text("About"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contexn) => const AboutScreen()));
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
