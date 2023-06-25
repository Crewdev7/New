import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:password_manager/src/models/list_model_provider.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../utils/mix.dart';

class DataListScreen extends StatelessWidget {
  const DataListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataListProvider>(context);
    var passwordLists = dataProvider.password;
    final listLength = passwordLists.length;
    // passwordLists = dataProvider.password;

    return Scaffold(
      appBar: AppBar(title: const Text("Store lists")),
      body: Column(
        children: [
          Card(
            elevation: 2,
            child: Text(listLength.toString()),
          ),
          Expanded(
            child: FutureBuilder<bool>(
                future: dataProvider.getEntries(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == false) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    children: dataProvider.password
                        .map((e) => _passwordtolist(context, e))
                        .toList(),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Container _passwordtolist(BuildContext context, PasswordData1 password) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(30)),
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,

        childrenPadding: const EdgeInsets.only(left: 32, top: 16, bottom: 16),
        collapsedIconColor: Colors.green,
        iconColor: Colors.lightBlue,
        leading: getIconForType(password.toEnumValue(password.passwordType,
            values: PasswordType.values)),
        // leading: getIconForType(password.passwordTypeIcon),
        title: Text(password.title),
        // trailing: IconButton(
        //   icon: const Icon(Icons.delete),
        //   onPressed: () {
        //     // dataProvider.removePassword(password.);
        //   },
        // ),
        children: [
          Text.rich(
            TextSpan(
                text: "Username:  ",
                children: [TextSpan(text: password.username)]),
          ),
          const SizedBox(
            height: 3,
          ),
          Text.rich(
            TextSpan(
              text: "Password:  ",
              children: [
                TextSpan(
                  text: password.password,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: "Password length:  ",
              children: [
                TextSpan(
                  text: password.passwordLength.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: "Created at:  ",
              children: [
                TextSpan(
                  text: password.createdAt.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          // For buttons to copy
          Row(
            children: [
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: password.password))
                        .then((value) => CherryToast.info(
                                title: const Text("Password copied!"))
                            .show(context));
                    MotionToast.success(
                      description: const Text("password copied"),
                      height: 50,
                      width: 300,
                    ).show(context);

                    CherryToast.success(
                      title: const Text("Password copied"),
                      toastPosition: Position.bottom,
                    ).show(context);
                  },
                  child: const Text("Copy password"),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: password.username));
                    Fluttertoast.showToast(msg: "username copied");

                    MotionToast.success(
                      description: const Text("username copied"),
                      height: 50,
                      width: 300,
                    ).show(context);

                    CherryToast.success(
                      title: const Text("Username copied"),
                      toastPosition: Position.bottom,
                    ).show(context);
                  },
                  child: const Text("Copy username"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
