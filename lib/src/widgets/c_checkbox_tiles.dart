import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../models/add_model_provider.dart';
import 'c_chars_dialog.dart';

final checkboxesData = [
  {
    "field": SourceFieldType.uppercase,
    "text": "Uppercase",
    "subtitle": "eg: ABC..YZ",
  },
  {
    "field": SourceFieldType.lowercase,
    "text": "Lowercase",
    "subtitle": "eg: abc..yz",
  },
  {
    "field": SourceFieldType.number,
    "text": "Number",
    "subtitle": "eg: 1234567890",
  },
  {
    "field": SourceFieldType.special,
    "text": "Special",
    "subtitle": "eg: !~@#%^&*(){}",
  },
  {
    "field": SourceFieldType.custom,
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

  bool isChecked(BuildContext context, SourceFieldType field) {
    switch (field) {
      case SourceFieldType.uppercase:
        return context.select((Sources p) => p.uppercase);
      case SourceFieldType.lowercase:
        return context.select((Sources p) => p.lowercase);
      case SourceFieldType.number:
        return context.select((Sources p) => p.number);
      case SourceFieldType.special:
        return context.select((Sources p) => p.special);
      case SourceFieldType.custom:
        return context.select((Sources p) => p.custom);
      default:
        // return context.select((Sources p) => p.lowercase);
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
                child: Text("Include:", style: TextStyle(fontSize: 20))),
            const Divider(),
            ListView.builder(
                itemCount: checkboxesData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    child: Builder(builder: (context) {
                      final checkbox = checkboxesData[index];
                      final field = checkbox['field'] as SourceFieldType;
                      final keyname = describeEnum(field);
                      String subtitle = checkbox['subtitle'] as String;
                      bool isCheckede = false;
                      final text = checkbox['text'] as String;

                      Function(bool?)? onChanged = (val) =>
                          context.read<Sources>().toggleSource(keyname, val!);
                      if (field == SourceFieldType.custom) {
                        final chars = context.read<Sources>().customChars;
                        if (chars.isNotEmpty) {
                          subtitle = chars;
                        } else {
                          onChanged = (v) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const CustomCharsDialog(toggle: true);
                                });
                          };
                        }
                      }

                      isCheckede = isChecked(context, field);
                      return CheckboxListTile(
                        onChanged: onChanged,
                        value: isCheckede,
                        title: Text(text),
                        subtitle: Text(subtitle),
                      );
                    }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
