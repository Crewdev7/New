import 'dart:math';

import 'package:flutter/material.dart';
import 'package:password_manager/src/password_list_provider.dart';
import 'package:provider/provider.dart';
import './utils/mix.dart';

enum PasswordType {
  email,
  website,
  username,
  android,
  ios,
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _userfieldController = TextEditingController();
  final _titlefieldController = TextEditingController();
  final _passwordController = TextEditingController();

// Little bit snappy i feel
  bool isLower = true;
  bool isNumber = true;
  bool isSpecial = true;
  bool isUpper = true;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<PasswordListProvider>(context);
    final userInputData = Provider.of<UserInputData>(context);

// to keep state while screen switching
    _passwordController.text = userInputData.password;
    _userfieldController.text = userInputData.username;
    _titlefieldController.text = userInputData.title;

    // This fix cursor moving to front
    _passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: _passwordController.text.length));

    _userfieldController.selection = TextSelection.fromPosition(
        TextPosition(offset: _userfieldController.text.length));

    var textStyle =
        const TextStyle(fontSize: 16, textBaseline: TextBaseline.ideographic);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<PasswordType>(
              onChanged: (v) {
                userInputData.changePasswordType(v!);
              },
              value: userInputData.passwordType, // set default value
              decoration: const InputDecoration(labelText: "Type"),
              items: PasswordType.values.map((type) {
                return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        getIconForType(type),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(type.toString().split(".").last)
                      ],
                    ));
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            ...[
              Consumer<UserInputData>(builder: (context, value, child) {
                return TextField(
                  controller: _titlefieldController,
                  onChanged: (value) {
                    userInputData.setTitle(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: getIconForType(userInputData.passwordType),
                    suffixIcon: IconButton(
                        onPressed: _titlefieldController.clear,
                        icon: const Icon(Icons.clear)),
                    labelText: "Title",
                  ),
                );
              }),
              Consumer<UserInputData>(builder: (context, value, child) {
                return TextField(
                  controller: _userfieldController,
                  onChanged: (value) {
                    userInputData.setUsername(value);
                  },
                  decoration: const InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.person),
                  ),
                );
              }),
              Consumer<UserInputData>(builder: (context, value, _) {
                return Row(
                  children: [
                    Text("${userInputData.username.length}"),
                  ],
                );
              }),
              Consumer<UserInputData>(builder: (context, value, child) {
                return TextField(
                  controller: _passwordController,
                  onChanged: (val) {
                    userInputData.setPassword(val);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password_outlined),
                    // ),
                    labelText: "password",
                  ),
                );
              }),

              Consumer<UserInputData>(builder: (context, value, _) {
                return Row(
                  children: [
                    Text("${userInputData.passLength}"),
                  ],
                );
              }),
              // Custom optnios
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Include:", style: TextStyle(fontSize: 20)),
                  ElevatedButton(
                    onPressed: () {
                      userInputData.genPassword();
                    },
                    child: const Text("Generate"),
                  ),
                ],
              ),

              Column(
                children: [
                  // TODO remmove consmuber becasu we are having local state in widget
                  Consumer<UserInputData>(
                    builder: (context, value, child) => Card(
                      child: CheckboxListTile(
                        value: value.isUppercase,
                        onChanged: (val) {
                          setState(() {
                            isUpper = val!;
                            userInputData.isUppercase = isUpper;
                          });
                        },
                        title: Text(
                          "Uppercase alphabets",
                          style: textStyle,
                        ),
                        subtitle: const Text("eg:  ABC..YZ"),
                      ),
                    ),
                  ),
                  Card(
                    child: CheckboxListTile(
                      onChanged: (bool? value) {
                        setState(() {});
                        isLower = value!;
                        userInputData.isLowercase = isLower;
                      },
                      value: isLower,
                      title: Text("Lowercase alphabets", style: textStyle),
                      subtitle: const Text("eg:  abc..yz"),
                    ),
                  ),
                  Card(
                      child: CheckboxListTile(
                    value: userInputData.isNumbers,
                    onChanged: (value) {
                      setState(() {
                        isNumber = value!;
                        userInputData.isNumbers = isNumber;
                      });
                    },
                    title: Text("Numbers", style: textStyle),
                    subtitle: const Text("eg:  12345.."),
                  )),
                  CheckboxListTile(
                    value: userInputData.isSpecialChars,
                    onChanged: (value) {
                      setState(() {
                        isSpecial = value!;
                        userInputData.isSpecialChars = isSpecial;
                      });
                    },
                    title: Text("Special charaters", style: textStyle),
                    subtitle: const Text("eg:   !`!#@ "),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text("Include custom charaters:",
                          style: TextStyle(fontSize: 20)),
                      Switch(
                          value: true,
                          onChanged: (value) {
// TODO imple
                          }),
                    ],
                  ),
                  TextField(
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                        label: Text("Custom charaters/letters")),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            dataProvider.addEntry(userInputData.getData);

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Password added")));
                          },
                          child: const Text("Add")),
                      ElevatedButton(
                          onPressed: () {
                            userInputData.resetFields();
                          },
                          child: const Text("Reset"))
                    ],
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

class UserInputData extends ChangeNotifier {
  String title = "";
  String username = "";
  String password = "";
  PasswordType passwordType = PasswordType.username;

  bool isUppercase = true;
  bool isLowercase = true;
  bool isNumbers = true;
  bool isSpecialChars = true;
  bool isCustom = false;
  int passwordLimit = 8;

  final letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final numbers = 1234567890;
  final specialChars = "~`!@#\$%^&*(){}/?+=-_|\\::\"";
  String? customChars;

  String generatedPass = "";
  int passLength = 0;

  void setTitle(value) {
    title = value;
  }

  void genPassword() {
    String letters1 = "";
    generatedPass = "";
    password = "";

    if (isUppercase) {
      letters1 += letters;
    }
    if (isLowercase) {
      letters1 += letters.toLowerCase();
    }
    if (isNumbers) {
      letters1 += numbers.toString();
    }
    if (isSpecialChars) {
      letters1 += specialChars;
    }
    if (isCustom && customChars != null) {
      letters1 += customChars!;
    }
    for (var i = 0; i < passwordLimit; i++) {
      var rand = Random();
      password += letters1[rand.nextInt(letters1.length)];
    }
    passLength = password.length;
    notifyListeners();
  }

  void resetFields({user = true, pass = true, title = true}) {
    if (user) {
      username = "";
    }
    if (pass) {
      password = "";
    }
    if (title) {
      title = "";
    }
    notifyListeners();
  }

  void setUsername(String value) {
    username = value;
    notifyListeners();
  }

  void setPassLength() {
    passLength = password.length;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    passLength = value.length;
    notifyListeners();
  }

  void changePasswordType(PasswordType type) {
    passwordType = type;
    notifyListeners();
  }

  String get getFieldName {
    var pass = passwordType.toString().split('.').last;
    return pass[0].toUpperCase() + pass.substring(1);
  }

  UserData get getData {
    return UserData(
        title: title,
        username: username,
        password: password,
        passwordType: passwordType,
        createdAt: DateTime.now(),
        passwordLength: passLength);
  }
}
