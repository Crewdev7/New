import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataListProvider>(context);
    final userInputData = Provider.of<InputDataProvider>(context);
    final sources = Provider.of<Sources>(context);
    final toggle = sources.toggleSource;

// to keep state while screen switching
    _passwordController.text = userInputData.getPassword;
    _userfieldController.text = userInputData.getUsername;
    _titlefieldController.text = userInputData.getTitle;

    // This fix cursor moving to front
    _passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: _passwordController.text.length));
    _userfieldController.selection = TextSelection.fromPosition(
        TextPosition(offset: _userfieldController.text.length));

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
              // Username
              CusInputTextField(
                  label: userInputData.getFieldName,
                  pIcon: getIconForType(userInputData.getPasswordType),
                  controller: _userfieldController,
                  onChange: (v) {
                    userInputData.setUsername = v;
                  }),
              LengthProvider(length: userInputData.getUsernameLength),

              // Password
              CusInputTextField(
                  label: "Password",
                  pIcon: const Icon(Icons.password),
                  controller: _passwordController,
                  onChange: (v) {
                    userInputData.setPassword = v;
                  }),
              LengthProvider(length: userInputData.getPasswordLength),

              const Center(
                  child: Text("Include:", style: TextStyle(fontSize: 20))),

              Column(
                children: [
                  Card(
                    child: CustomCheckboxTile(
                      ischeckd: true,
                      text: "Uppercase",
                      subtitle: "eg:  ABC..YZ",
                      onChange: toggle,
                      keyname: "uppercase",
                    ),
                  ),
                  Card(
                    child: CustomCheckboxTile(
                      ischeckd: true,
                      text: "Lowercase",
                      subtitle: "eg:  abc..yz",
                      onChange: toggle,
                      keyname: "lowercase",
                    ),
                  ),
                  Card(
                    child: CustomCheckboxTile(
                      // ischeckd: isChecked,
                      ischeckd: true,
                      text: "Numbers",
                      subtitle: "eg:  1234567890",
                      onChange: toggle,
                      keyname: "number",
                    ),
                  ),
                  Card(
                    child: CustomCheckboxTile(
                      ischeckd: true,
                      text: "Special chars.",
                      subtitle: "eg:  `~!@#\$%^&*(){}|+?_/-_...",
                      onChange: toggle,
                      keyname: "special",
                    ),
                  ),
                  const Divider(),
                  const Row(
                    children: [
                      Text("Include custom charaters:",
                          style: TextStyle(fontSize: 20)),
                      Switch(value: true, onChanged: null)
                    ],
                  ),
                  TextField(
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                        label: Text("Custom charaters/letters")),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: ElevatedButton(
                              onPressed: () {
                                dataProvider
                                    .addEntry(userInputData.getInputData);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Password added")));
                              },
                              child: const Text("Add")),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: ElevatedButton(
                              onPressed: () {
                                userInputData.resetFields();
                              },
                              child: const Text("Reset")),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ].expand((element) => [
                  element,
                  const SizedBox(
                    height: 20,
                  )
                ])
          ],
        ),
      ),
    );
  }
}

class CustomCheckboxTile extends StatelessWidget {
  final String text;
  final String subtitle;
  final onChange;
  final String keyname;
  // bool value;
  bool ischeckd;

  var checked = false;
  CustomCheckboxTile({
    super.key,
    required this.text,
    required this.onChange,
    required this.ischeckd,
    required this.subtitle,
    required this.keyname,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: (val) {
        checked = onChange(keyname, val);
      },
      value: checked,
      title: Text(text),
      subtitle: Text(subtitle),
    );
  }
}

class TypeDropdown extends StatelessWidget {
  final String label;
  const TypeDropdown({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final passwordModel = Provider.of<InputDataProvider>(context);
    final passwordType = passwordModel.getPasswordType;
    return DropdownButtonFormField<PasswordType>(
      value: passwordType, // set default value
      onChanged: (v) {
        passwordModel.setPasswordType = v!;
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
  final Icon pIcon;
  final controller;
  final onChange;
  final String label;

  const CusInputTextField({
    super.key,
    required this.pIcon,
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
        prefixIcon: pIcon,
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
