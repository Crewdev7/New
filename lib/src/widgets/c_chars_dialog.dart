import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/add_model_provider.dart';

class CustomCharsDialog extends StatelessWidget {
  final bool? toggle;
  const CustomCharsDialog({super.key, this.toggle});

  @override
  Widget build(BuildContext context) {
    final customCharController = TextEditingController();
    var customChars = context.read<Sources>();
    customCharController.text = customChars.customChars;
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
              final text = customCharController.text.replaceAll(" ", "");
              if (text.isNotEmpty) {
                customChars.customChars = text;
                if (toggle != null) {
                  customChars.custom = true;
                }
              }
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
