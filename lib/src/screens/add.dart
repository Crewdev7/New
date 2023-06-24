import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/models/add_model_provider.dart';
import 'package:password_manager/src/models/list_model_provider.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../utils/mix.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _userfieldController = TextEditingController();
  final _titlefieldController = TextEditingController();
  final _passwordController = TextEditingController();

  final _customCharController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataListProvider>();
    final userInputData = /* Provider.of<InputDataProvider>(context); */

        context.watch<InputDataProvider>();
    final boxstate = context.watch<Sources>();
    final toggleCheckbox = boxstate.toggleSource;
    final isChecked = boxstate.isChecked;
    final passwordType = userInputData.passwordType;

    final usernameTitle = userInputData.title;
    var username = userInputData.username;
    var password = userInputData.password;
    final usernameLength = userInputData.usernameLength;
    final passwordLength = userInputData.passwordLength;
    final titleLength = userInputData.title.length;

// to keep state while screen switching
    _passwordController.text = password;
    _userfieldController.text = username;
    _titlefieldController.text = usernameTitle;

    _customCharController.text = boxstate.customChars;

    // This fix cursor moving to front
    _passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: _passwordController.text.length));
    _userfieldController.selection = TextSelection.fromPosition(
        TextPosition(offset: _userfieldController.text.length));

    _titlefieldController.selection = TextSelection.fromPosition(
        TextPosition(offset: _titlefieldController.text.length));

    return MyScaffold(
      appBarTitle: "Dashboard",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown menu for type selection
            TypeDropdown(
              label: "Type",
            ),
            const SizedBox(height: 20),

            ...[
              // Title
              CusInputTextField(
                  label: "Title",
                  // leadingIcon: const Icon(Icons.one_k_plus),
                  controller: _titlefieldController,
                  onChange: (v) {
                    userInputData.title = v;
                  }),
              LengthProvider(length: titleLength),

              // Username
              CusInputTextField(
                  label: "Username",
                  leadingIcon: getIconForType(passwordType),
                  controller: _userfieldController,
                  onChange: (v) {
                    userInputData.username = v;
                  }),
              LengthProvider(length: usernameLength),

              // Password
              CusInputTextField(
                  label: "Password",
                  leadingIcon: const Icon(Icons.password),
                  controller: _passwordController,
                  onChange: (v) {
                    userInputData.password = v;
                  }),
              LengthProvider(length: passwordLength),
              Center(
                  child: Row(
                children: [
                  Expanded(
                    child: Slider(
                        min: 1,
                        max: 100,
                        value: boxstate.getPasswordLimit.toDouble(),
                        onChanged: (v) {
                          boxstate.setPasswordLimit = v.toInt();
                        }),
                  ),
                  Text(boxstate.getPasswordLimit.toString()),
                ],
              )),

              const Center(
                  child: Text("Include:", style: TextStyle(fontSize: 20))),
// Move state up maybe
              Column(
                children: [
                  Card(
                    child: CustomCheckboxTile(
                      text: "Uppercase",
                      subtitle: "eg:  ABC..YZ",
                      onChange: boxstate,
                      keyname: "uppercase",
                    ),
                  ),
                  Card(
                    child: CustomCheckboxTile(
                      text: "Lowercase",
                      subtitle: "eg:  abc..yz",
                      onChange: boxstate,
                      keyname: "lowercase",
                    ),
                  ),
                  Card(
                    child: CustomCheckboxTile(
                      text: "Numbers",
                      subtitle: "eg:  1234567890",
                      onChange: boxstate,
                      keyname: "number",
                    ),
                  ),
                  Card(
                    child: CustomCheckboxTile(
                      text: "Special chars.",
                      subtitle: "eg:  `~!@#\$%^&*(){}|+?_/-_...",
                      onChange: boxstate,
                      keyname: "special",
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text("Include custom charaters:",
                          style: TextStyle(fontSize: 20)),
                      Switch(
                          value: boxstate.custom,
                          onChanged: (v) {
                            boxstate.toggleSource('custom', v);
                          })
                    ],
                  ),
                  boxstate.custom
                      ? TextField(
                          maxLines: 5,
                          minLines: 1,
                          controller: _customCharController,
                          onChanged: (value) {
                            boxstate.customChars = value;
                          },
                          decoration: const InputDecoration(
                              label: Text("Custom charaters/letters")),
                        )
                      : const Divider(),
                  const SizedBox(height: 20),
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
                    dataProvider.add(userInputData.getInputData);
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
              child: FloatingActionButton(
                  onPressed: () {
                    boxstate.getSource();
                    userInputData.generatedPassword(
                        boxstate.source, boxstate.getPasswordLimit);
                    print("password is:$password");
                    print("password length:$passwordLength");
                  },
                  child: const Text("Passy")),
            ),
            const SizedBox(
              width: 30,
            ),
            Transform.scale(
              scale: 1.3,
              child: FloatingActionButton(
                  onPressed: () {
                    userInputData.resetFields();
                  },
                  child: const Text("Reset")),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCheckboxTile extends StatelessWidget {
  final String text;
  final String subtitle;
  final Sources onChange;
  final String keyname;

  const CustomCheckboxTile({
    super.key,
    required this.text,
    required this.onChange,
    required this.subtitle,
    required this.keyname,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: (val) {
        if (kDebugMode) {
          print("checkbokvalue: $val");
        }
        onChange.toggleSource(keyname, val!);
      },
      value: onChange.isChecked(keyname),
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
        print("hey:$v");
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

class CusInputTextField extends StatelessWidget {
  final Icon? leadingIcon;
  final TextEditingController controller;
  final Function(dynamic) onChange;
  final String label;

  const CusInputTextField({
    super.key,
    this.leadingIcon,
    required this.controller,
    required this.onChange,
    required this.label,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (v) {
        onChange(v);
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: leadingIcon,
      ),
    );
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
