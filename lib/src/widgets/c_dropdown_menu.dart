import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../models/add_model_provider.dart';

class CustomDropdownMenu extends StatelessWidget {
  final String label;
  const CustomDropdownMenu({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    var passwordType = context.select((InputDataProvider p) => p.passwordType);

    return DropdownButtonFormField<PasswordType>(
      value: passwordType, // set default value
      onChanged: (v) {
        context.read<InputDataProvider>().passwordType = v!;
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
