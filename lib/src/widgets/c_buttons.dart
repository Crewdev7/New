import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/add_model_provider.dart';
import '../models/list_model_provider.dart';

class CustomButtons extends StatelessWidget {
  const CustomButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            context
                .read<DataListProvider>()
                .add(context.read<InputDataProvider>().getInputData);
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
                context
                    .read<InputDataProvider>()
                    .generatePassword(source.source, source.getPasswordLimit);
              },
              child: const Text("Passy")),
        ),
        const SizedBox(
          width: 30,
        ),
        ElevatedButton(onPressed: () {}, child: const Text("Reset")),
      ],
    );
  }
}
