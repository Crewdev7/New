import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/src/models/list_model_provider.dart';
import 'package:password_manager/src/utils/mix.dart';
import 'package:provider/provider.dart';

class DataListScreen extends StatefulWidget {
  const DataListScreen({Key? key}) : super(key: key);

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  List<PasswordData1> passwordLists = [];
  List<bool> _selectedStates = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    final dataProvider = Provider.of<DataListProvider>(context, listen: false);
    dataProvider.getEntries().then((success) {
      if (success) {
        setState(() {
          passwordLists = dataProvider.password;
          _selectedStates =
              List<bool>.generate(passwordLists.length, (index) => false);
        });
      }
    }).onError((error, stackTrace) {});
  }

  void _togglePasswordSelection(int index) {
    setState(() {
      final isSelected = _selectedStates[index];
      if (isSelected) {
        _selectedStates[index] = !_selectedStates[index];
      } else {
        _selectedStates[index] = !_selectedStates[index];
      }
    });
  }

  void _deleteSelectedPasswords() {
    final dataProvider = Provider.of<DataListProvider>(context, listen: false);
    List<PasswordData1> selectedPasswords = [];
    for (int i = 0; i < passwordLists.length; i++) {
      if (_selectedStates[i]) {
        selectedPasswords.add(passwordLists[i]);
      }
    }

    for (var password in selectedPasswords) {
      dataProvider.remove(password.id!);
    }

    setState(() {
      _selectedStates =
          List<bool>.generate(passwordLists.length, (index) => false);
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataListProvider>(context);
    passwordLists = dataProvider.password;

    return MyScaffold(
      appBarTitle:
          "Store lists ${context.select((DataListProvider p) => p.password.length)}",
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: passwordLists.length,
              itemBuilder: (context, index) {
                final password = passwordLists[index];
                final isSelected = _selectedStates[index];

                var paswordExpentionTile = Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    color: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withAlpha(90)
                        : Theme.of(context).colorScheme.secondary.withAlpha(50),
                  ),
                  child: ExpansionTile(
                    maintainState: true,
                    leading: const Icon(Icons.lock),
                    title: Text(password.title),
                    trailing: isSelected ? const Icon(Icons.delete) : null,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username: ${password.username}'),
                            Text('Password: ${password.password}'),
                            Text('Password length: ${password.passwordLength}'),
                            Text('Created at: ${password.createdAt}'),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                            text: password.password))
                                        .then((value) => Fluttertoast.showToast(
                                            msg: 'Password copied'));
                                  },
                                  child: const Text("Copy password"),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                            text: password.username))
                                        .then((value) => Fluttertoast.showToast(
                                            msg: 'Username copied'));
                                  },
                                  child: const Text("Copy username"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 20),
                    ],
                  ),
                );
                return InkWell(
                  onLongPress: () {
                    _togglePasswordSelection(index);
                  },
                  child: paswordExpentionTile,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedStates.contains(true)
          ? FloatingActionButton(
              onPressed: _deleteSelectedPasswords,
              child: const Icon(Icons.delete),
            )
          : null,
    );
  }
}
