import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/models/add_model_provider.dart';
import 'package:password_manager/src/models/app_model_provider.dart';
import 'package:password_manager/src/screens/about.dart';
import 'package:password_manager/src/screens/add.dart';
import 'package:password_manager/src/utils/mix.dart';
import 'package:provider/provider.dart';

class CustomCharsDialog extends StatelessWidget {
  const CustomCharsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final customCharController = TextEditingController();
    var source = context.read<Sources>();

    customCharController.text = source.customChars;
    return AlertDialog(
      content: TextField(
        maxLines: 5,
        minLines: 1,
        controller: customCharController,
        decoration:
            const InputDecoration(label: Text("Custom charaters/letters")),
      ),
      actions: [
        TextButton(
            onPressed: () {
              source.customChars = customCharController.text;
              Navigator.pop(context);
            },
            child: const Text("Ok")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
      ],
    );
  }
}

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // using watch works in such a way that we dont have to  wrap all of these in any consumber
    // if you change value from any where its value will we reflected here too
    var isDark = context.watch<AppProvider>();
    final sourceRead = context.read<Sources>();
    final sourceWatch = context.watch<Sources>();

    return MyScaffold(
      appBarTitle: "Settings",
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SwitchListTile(
                  value: isDark.isDark,
                  title: const Text("Enable Darkmode"),
                  onChanged: (v) {
                    isDark.toggle();
                  }),
              SwitchListTile(
                  value: context.select((Sources p) => p.custom),
                  title: const Text("Enable Custom letters"),
                  onChanged: (v) {
                    if (!sourceWatch.custom &&
                        sourceWatch.customChars.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => const CustomCharsDialog(),
                      );
                      return;
                    }
                    sourceRead.toggleSource(
                        describeEnum(CheckboxField.custom), v);
                  }),
              sourceWatch.customChars.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(sourceRead.customChars),
                          ButtonBar(
                            children: [
                              sourceWatch.custom
                                  ? Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            sourceRead.customChars = "";
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
                                  : Divider(),
                            ],
                          )
                        ],
                      ),
                    )
                  : sourceWatch.custom
                      ? IconButton(onPressed: () {}, icon: Icon(Icons.add))
                      : SizedBox(),
              const ListTile(
                title: Text("Backup and restore"),
              ),
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
