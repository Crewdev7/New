import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/add_model_provider.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      children: [
        Expanded(
          child: Slider(
              min: 1,
              max: 50,
              value:
                  context.select((Sources p) => p.getPasswordLimit.toDouble()),
              onChanged: (v) {
                context.read<Sources>().setPasswordLimit = v.toInt();
              }),
        ),
        Text(context.read<Sources>().getPasswordLimit.toString()),
      ],
    ));
  }
}
