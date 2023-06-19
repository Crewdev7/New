import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard_screen.dart';
import 'password_list_provider.dart';

class PasswordListScreen extends StatelessWidget {
  const PasswordListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<PasswordListProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Store lists")),
      body: ListView.builder(
          itemCount: dataProvider.passwords.length,
          itemBuilder: (context, index) {
            final password = dataProvider.passwords[index];

            return Container(
              margin: EdgeInsets.only(bottom: 30, top: 26),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withAlpha(23)),
              child: ExpansionTile(
                  leading: _getIconForType(password.passwordType),
                  title: Text(password.title),
                  // trailing: IconButton(
                  //   icon: const Icon(Icons.delete),
                  //   onPressed: () {
                  //     // dataProvider.removePassword(password.);
                  //   },
                  // ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  childrenPadding:
                      EdgeInsets.only(left: 32, top: 16, bottom: 16),
                  collapsedIconColor: Colors.green,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: "Username:  ",
                          children: [TextSpan(text: password.username)]),
                    ),
                  ]),
            );
          }),
    );
  }
}

_getIconForType(PasswordType type) {
  switch (type) {
    case PasswordType.email:
      return const Icon(Icons.email);
    case PasswordType.ios:
      return const Icon(Icons.iso);
    case PasswordType.android:
      return const Icon(Icons.android);

    case PasswordType.username:
      return const Icon(Icons.verified_user);
    case PasswordType.website:
      return const Icon(Icons.web_sharp);
    default:
      return const Icon(Icons.verified_user_sharp);
  }
}
