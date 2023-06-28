import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/src/models/add_model_provider.dart';
import 'package:password_manager/src/models/list_model_provider.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../utils/mix.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  void fetchData(context) {
    final dataProvider = Provider.of<Sources>(context, listen: false);
    dataProvider.initPref().then((success) {
      if (success) {
        print("init pref is success");
        writeToLogFile("init data fatched success");
      }
    }).onError((error, stackTrace) {
      print("you have eerror while intialization of Sources");
      writeToLogFile("you have eerror while intialization of Sources");
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchData(context);
    return MyScaffold(
      appBarTitle: "Dashboard",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown menu for type selection
              const TypeDropdown(label: "Type"),
              const SizedBox(height: 20),

              ...[
                const CusInputTextFieldd(Key("title"),
                    fields: InpputField.title),

                const CusInputTextFieldd(Key("username"),
                    fields: InpputField.username),

                const CusInputTextFieldd(Key("password"),
                    fields: InpputField.password),

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
                            context.read<Sources>().setPasswordLimit =
                                v.toInt();
                          }),
                    ),
                    Text(context.read<Sources>().getPasswordLimit.toString()),
                  ],
                )),
                //Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<DataListProvider>().add(
                            context.read<InputDataProvider>().getInputData);
                      },
                      child: const Text("Add"),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Transform.scale(
                      scale: 1.4,
                      child: ElevatedButton(
                          onPressed: () {
                            var source = context.read<Sources>();
                            source.getSource();
                            context.read<InputDataProvider>().generatePassword(
                                source.source, source.getPasswordLimit);
                          },
                          child: const Text("Passy")),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Reset")),
                  ],
                ),
                const Center(
                    child: Text("Include:", style: TextStyle(fontSize: 20))),
// Move state up maybe
                const Column(
                  children: [
                    CustomCheckboxTile(),
                    Divider(),
                    Row(
                      children: [
                        Text("Include custom charaters:",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    TextField(
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                          label: Text("Custom charaters/letters")),
                    ),
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
  customChars,
  passwordLimit,
}

final checkboxesData = [
  {
    "field": CheckboxField.uppercase,
    "text": "Uppercase",
    "subtitle": "eg: ABC..YZ",
  },
  {
    "field": CheckboxField.lowercase,
    "text": "Lowercase",
    "subtitle": "eg: abc..yz",
  },
  {
    "field": CheckboxField.number,
    "text": "Number",
    "subtitle": "eg: 1234567890",
  },
  {
    "field": CheckboxField.special,
    "text": "Special",
    "subtitle": "eg: !~@#%^&*(){}",
  },
  {
    "field": CheckboxField.custom,
    "text": "Custom",
    "subtitle": "eg: Your words here",
  },
];

class CustomCheckboxTile extends StatelessWidget {
  // final String keyname;

  // final CheckboxField field;

  const CustomCheckboxTile({
    super.key,
    // required this.keyname,
  });

  void handleCheckboxChanged(
      BuildContext context, CheckboxField field, bool value) {
    final data = context.read<Sources>().toggleSource;

    data(field.toString(), value);
  }

  bool isChecked(BuildContext context, CheckboxField field) {
    switch (field) {
      case CheckboxField.uppercase:
        return context.select((Sources p) => p.uppercase);
      case CheckboxField.lowercase:
        return context.select((Sources p) => p.lowercase);
      case CheckboxField.number:
        return context.select((Sources p) => p.number);
      case CheckboxField.special:
        return context.select((Sources p) => p.special);
      case CheckboxField.custom:
        return context.select((Sources p) => p.custom);
      default:
        // return context.select((Sources p) => p.lowercase);
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: checkboxesData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            elevation: 1,
            child: Builder(builder: (context) {
              final checkbox = checkboxesData[index];
              final field = checkbox['field'] as CheckboxField;

              final text = checkbox['text'] as String;
              final subtitle = checkbox['subtitle'] as String;
              bool isCheckede = false;

              isCheckede = isChecked(context, field);
              final keyname = describeEnum(field);

              print("inside listvied field:$field");
              return CheckboxListTile(
                onChanged: (val) =>
                    context.read<Sources>().toggleSource(keyname, val!),
                value: isCheckede,
                title: Text(text),
                subtitle: Text(subtitle),
              );
            }),
          );
        });
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
    final inpuData = context.read<InputDataProvider>();

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
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: text,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: getLabel(),
              prefixIcon: getLeadingIcon(),
            ),
          ),
        ),
        Text(text.text.length.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final txtCntl = TextEditingController();
    void Function(String) onChanged = (v) {};

    switch (fields) {
      case InpputField.username:
        txtCntl.text = context.select((InputDataProvider p) => p.username);
        onChanged = getOnChanged(context);
        break;

      case InpputField.title:
        txtCntl.text = context.select((InputDataProvider p) => p.title);
        onChanged = getOnChanged(context);
        break;

      case InpputField.password:
        txtCntl.text = context.select((InputDataProvider p) => p.password);
        onChanged = getOnChanged(context);
        break;
      default:
        break;
    }
    txtCntl.selection =
        TextSelection.fromPosition(TextPosition(offset: txtCntl.text.length));
    return builtTextField(context, txtCntl, onChanged);
  }
}
