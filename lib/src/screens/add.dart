import 'package:flutter/material.dart';

import '../utils/mix.dart';
import '../widgets/c_buttons.dart';
import '../widgets/c_checkbox_tiles.dart';
import '../widgets/c_dropdown_menu.dart';
import '../widgets/c_input_text.dart';
import '../widgets/c_slider.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBarTitle: "Dashboard",
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown menu for type selection
              // const SizedBox(height: 20),

              ...[
                const CustomDropdownMenu(label: "Type"),
                // Input fields
                const CustomTextInputField(Key("title"),
                    inputType: InputFieldType.title),
                const CustomTextInputField(Key("username"),
                    inputType: InputFieldType.username),
                const CustomTextInputField(Key("password"),
                    inputType: InputFieldType.password),

                // Slider
                const CustomSlider(),

                // Buttons
                const CustomButtons(),

                // Checkbox for source
                const CustomCheckboxTile(),
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
