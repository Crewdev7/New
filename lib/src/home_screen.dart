import 'package:flutter/material.dart';
import 'package:password_manager/src/password_list_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordListProvider = Provider.of<PasswordListProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView.builder(
          itemCount: passwordListProvider.passwords.length,
          itemBuilder: (context, index) {
            final password = passwordListProvider.passwords[index];
            return ListTile(
                title: Text(password),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    passwordListProvider.removePassword(password);
                  },
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String? newPassword;
                return AlertDialog(
                  title: const Text("Add password"),
                  content: TextField(
                    onChanged: (value) {
                      newPassword = value;
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                      filled: true,
                    ),
                    autofocus: true,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel")),
                    TextButton(
                      onPressed: () {
                        if (newPassword != null && newPassword!.isNotEmpty) {
                          passwordListProvider.addPassword(newPassword!);
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text("Add"),
                    )
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
