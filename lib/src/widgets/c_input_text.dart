import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/add_model_provider.dart';

enum InputFieldType {
  username,
  password,
  title,
}

class CustomTextInputField extends StatelessWidget {
  final InputFieldType inputType;

  const CustomTextInputField(Key? key, {required this.inputType})
      : super(key: key);

  String getLabel() {
    switch (inputType) {
      case InputFieldType.username:
        return 'Username';
      case InputFieldType.password:
        return "Password";
      case InputFieldType.title:
        return "Title";
      default:
        return "Unkown";
    }
  }

  Icon? getLeadingIcon() {
    switch (inputType) {
      case InputFieldType.password:
        return const Icon(Icons.password);
      case InputFieldType.title:
        return const Icon(Icons.title);
      case InputFieldType.username:
        return const Icon(Icons.person_2);
      default:
        return const Icon(Icons.question_mark);
    }
  }

  void Function(String) getOnChanged(BuildContext context) {
    final inpuData = context.read<InputDataProvider>();

    switch (inputType) {
      case InputFieldType.username:
        return (v) {
          inpuData.username = v;
        };
      case InputFieldType.title:
        return (v) {
          inpuData.title = v;
        };
      case InputFieldType.password:
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

    switch (inputType) {
      case InputFieldType.username:
        txtCntl.text = context.select((InputDataProvider p) => p.username);
        onChanged = getOnChanged(context);
        break;

      case InputFieldType.title:
        txtCntl.text = context.select((InputDataProvider p) => p.title);
        onChanged = getOnChanged(context);
        break;

      case InputFieldType.password:
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
