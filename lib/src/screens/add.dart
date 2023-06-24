import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/models/add_model_provider.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../utils/mix.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBarTitle: "Dashboard",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown menu for type selection
            const TypeDropdown(label: "Type"),
            const SizedBox(height: 20),

            ...[
              const CusInputTextFieldd(Key("title"), fields: InpputField.title),

              Row(
                children: [
                  Text(
                      "Title length: ${context.select((InputDataProvider p) => p.title.length)}"),
                ],
              ),

              const CusInputTextFieldd(Key("username"),
                  fields: InpputField.username),

              Row(
                children: [
                  Text(
                      "Username length: ${context.select((InputDataProvider p) => p.username.length)}"),
                ],
              ),

              const CusInputTextFieldd(Key("poassword"),
                  fields: InpputField.password),

              Row(
                children: [
                  Text(
                      "Password length: ${context.select((InputDataProvider p) => p.password.length)}"),
                ],
              ),

              Center(
                  child: Row(
                children: [
                  Expanded(
                    child: Slider(
                        min: 1,
                        max: 100,
                        value: context.select(
                            (Sources p) => p.getPasswordLimit.toDouble()),
                        onChanged: (v) {
                          context.read<Sources>().setPasswordLimit = v.toInt();
                        }),
                  ),
                  // Text(getPasswordLimit.toString()),
                ],
              )),

              const Center(
                  child: Text("Include:", style: TextStyle(fontSize: 20))),
// Move state up maybe
              const Column(
                children: [
                  Card(
                    child: CustomCheckboxTile(
                      field: CheckboxField.uppercase,
                      text: "Uppercase",
                      subtitle: "eg:  ABC..YZ",
                      keyname: "uppercase",
                    ),
                  ),
                  Card(
                    child: CustomCheckboxTile(
                      field: CheckboxField.lowercase,
                      text: "Lowercase",
                      subtitle: "eg:  abc..yz",
                      keyname: "lowercase",
                    ),
                  ),
                  Card(
                    child: CustomCheckboxTile(
                      field: CheckboxField.number,
                      text: "Numbers",
                      subtitle: "eg:  1234567890",
                      keyname: "number",
                    ),
                  ),
                  Card(
                    child: CustomCheckboxTile(
                      field: CheckboxField.special,
                      text: "Special chars.",
                      subtitle: "eg:  `~!@#\$%^&*(){}|+?_/-_...",
                      keyname: "special",
                    ),
                  ),
                  Divider(),
                  // Row(
                  //   children: [
                  //     const Text("Include custom charaters:",
                  //         style: TextStyle(fontSize: 20)),
                  //     Switch(
                  //         value: boxstate.custom,
                  //         onChanged: (v) {
                  //           boxstate.toggleSource('custom', v);
                  //         })
                  //   ],
                  // ),
                  // boxstate.custom
                  //     ? TextField(
                  //         maxLines: 5,
                  //         minLines: 1,
                  //         controller: _customCharController,
                  //         onChanged: (value) {
                  //           boxstate.customChars = value;
                  //         },
                  //         decoration: const InputDecoration(
                  //             label: Text("Custom charaters/letters")),
                  //       )
                  //     : const Divider(),
                  SizedBox(height: 20),
                ],
              ),
            ].expand((element) => [
                  element,
                  const SizedBox(
                    height: 20,
                  )
                ]),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Transform.scale(
                scale: 1.3,
                child: FloatingActionButton(
                  onPressed: () {
                    print("add");
                    // dataProvider.add(userInputData.getInputData);
                  },
                  child: const Text("Add"),
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Transform.scale(
              scale: 1.3,
              child: ElevatedButton(
                  onPressed: () {
                    var source = context.read<Sources>();

                    source.getSource();
                    context.read<InputDataProvider>().generatedPassword(
                        source.source, source.getPasswordLimit);
                  },
                  child: const Text("Passy")),
            ),
            const SizedBox(
              width: 30,
            ),
            Transform.scale(
              scale: 1.3,
              child:
                  ElevatedButton(onPressed: () {}, child: const Text("Reset")),
            ),
          ],
        ),
      ),
    );
  }
}

enum CheckboxField {
  uppercase,
  lowercase,
  number,
  special,
  custom,
}

class CustomCheckboxTile extends StatelessWidget {
  final String text;
  final String subtitle;
  final String keyname;

  final CheckboxField field;

  const CustomCheckboxTile({
    super.key,
    required this.field,
    required this.text,
    required this.subtitle,
    required this.keyname,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.read<Sources>();
    final watchedData = context.watch<Sources>();
    bool isChecked = false;
    Function(bool?)? onChanged = (v) {};

    switch (field) {
      case CheckboxField.uppercase:
        isChecked = context.select((Sources p) => p.uppercase);
        onChanged = (value) {
          data.toggleSource(keyname, value!);
          // watchedData.uppercase = value!;
        };
        break;
      case CheckboxField.lowercase:
        isChecked = watchedData.lowercase;
        onChanged = (value) {
          data.toggleSource(keyname, value!);
        };
        break;
      case CheckboxField.number:
        isChecked = watchedData.number;
        onChanged = (value) {
          data.toggleSource(keyname, value!);
        };
        break;
      case CheckboxField.custom:
        isChecked = data.custom;
        onChanged = (value) {
          data.toggleSource(keyname, value!);
        };
        break;
      case CheckboxField.special:
        isChecked = data.special;
        onChanged = (value) {
          data.toggleSource(keyname, value!);
        };
        break;
      default:
        isChecked = data.special;
        onChanged = (value) {
          data.toggleSource(keyname, value!);
        };
        break;
    }

    return CheckboxListTile(
      onChanged: onChanged,
      value: isChecked,
      title: Text(text),
      subtitle: Text(subtitle),
    );
  }
}

class TypeDropdown extends StatelessWidget {
  final String label;
  const TypeDropdown({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    var passwordType = context.select((InputDataProvider p) => p.passwordType);
    return DropdownButtonFormField<PasswordType>(
      value: passwordType, // set default value
      onChanged: (v) {
        context.read<InputDataProvider>().spasswordType(v!);
      },
      decoration: InputDecoration(labelText: label),
      items: PasswordType.values.map((type) {
        return DropdownMenuItem(
            value: type,
            child: Row(
              children: [
                getIconForType(type),
                const SizedBox(width: 8.0),
                Text(type.toString().split(".").last)
              ],
            ));
      }).toList(),
    );
  }
}

enum InpputField {
  username,
  password,
  title,
}

class CusInputTextFieldd extends StatelessWidget {
  final InpputField fields;

  const CusInputTextFieldd(Key? key, {required this.fields}) : super(key: key);

  String getLabel() {
    switch (fields) {
      case InpputField.username:
        return 'Username';
      case InpputField.password:
        return "Password";
      case InpputField.title:
        return "Title";
      default:
        return "Unkown";
    }
  }

  Icon? getLeadingIcon() {
    switch (fields) {
      case InpputField.password:
        return const Icon(Icons.password);
      case InpputField.title:
        return const Icon(Icons.title);

      default:
        return const Icon(Icons.question_mark);
    }
  }

  void Function(String) getOnChanged(
    BuildContext context,
  ) {
    final inpuData = Provider.of<InputDataProvider>(context);

    switch (fields) {
      case InpputField.username:
        return (v) {
          inpuData.username = v;
        };
      case InpputField.title:
        return (v) {
          inpuData.title = v;
        };
      case InpputField.password:
        return (v) {
          inpuData.password = v;
        };
      default:
        return (v) {};
    }
  }

  Widget builtTextField(BuildContext context, TextEditingController text,
      void Function(String) onChanged) {
    return TextField(
      controller: text,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: getLabel(),
        prefixIcon: getLeadingIcon(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final txtCntl = TextEditingController();
    return Consumer<InputDataProvider>(builder: (context, inputData, _) {
      void Function(String) onChanged = (v) {};

      switch (fields) {
        case InpputField.username:
          txtCntl.text = inputData.username;
          onChanged = getOnChanged(context);
          break;

        case InpputField.title:
          txtCntl.text = inputData.title;
          onChanged = getOnChanged(context);
          break;

        case InpputField.password:
          txtCntl.text = inputData.password;
          // ignore: unused_label
          onChanged = getOnChanged(context);
          break;
        default:
          break;
      }
      txtCntl.selection =
          TextSelection.fromPosition(TextPosition(offset: txtCntl.text.length));
      return builtTextField(context, txtCntl, onChanged);
    });
  }
}

class LengthProvider extends StatelessWidget {
  final int length;
  const LengthProvider({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(length.toString()),
      ],
    );
  }
}
