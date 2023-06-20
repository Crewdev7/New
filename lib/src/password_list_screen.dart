import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'password_list_provider.dart';
import 'utils/mix.dart';

class PasswordListScreen extends StatelessWidget {
  const PasswordListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<PasswordListProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Store lists")),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 26, bottom: 30),
          physics: const BouncingScrollPhysics(),
          itemCount: dataProvider.passwords.length,
          itemBuilder: (context, index) {
            final password = dataProvider.passwords[index];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withAlpha(30)),
              child: ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.start,

                childrenPadding:
                    const EdgeInsets.only(left: 32, top: 16, bottom: 16),
                collapsedIconColor: Colors.green,
                iconColor: Colors.lightBlue,
                leading: getIconForType(password.passwordType),
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
                          onPressed: () {},
                          child: const Text("Copy password"),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Copy username"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
