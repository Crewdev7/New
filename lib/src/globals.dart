import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const appName = "Passy";
const appTitle = "Passy Password Manager";
const version = "0.2";
const author = "CrewD";
const description = "This app is for managing passwords  safely";
const license = "Opensource";
const githubUrl = "githubUrl";
const website = "mysite";

getIconForType(PasswordType type) {
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
    case PasswordType.unknown:
      return const Icon(Icons.undo);
    default:
      return const Icon(Icons.verified_user_sharp);
  }
}

enum SourceFieldType {
  uppercase,
  lowercase,
  number,
  special,
  custom,
  customChars,
  passwordLimit,
}

enum PasswordType {
  email,
  website,
  username,
  android,
  ios,
  unknown,
}

class PasswordData {
  final String title;
  final String username;
  final String password;
  final int passwordLength;
  final PasswordType passwordType;
  final DateTime createdAt;
  final int? id;

  PasswordData({
    required this.title,
    required this.username,
    required this.password,
    required this.passwordType,
    required this.createdAt,
    required this.passwordLength,
    this.id,
  });
  // PasswordData.fromJsonMap(Map<String, dynamic> map)
  //     : id = map['id'] as int,
  //       title = map['title'] as String,
  //       password = map['password'] as String,
  //       username = map['username'] as String,
  //       passwordType = map['passwordType'] as PasswordType,
  //       createdAt =
  //           DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
  //       passwordLength = map['passwordLength'] as String;
  //
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'username': username,
        'password': password,
        'passwordLength': passwordLength.toString(),
        'passwordType': passwordType.toString(),
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}

Future<void> writeToLogFile(String message) async {
  final directory = await getApplicationSupportDirectory();
  final filePath = File("${directory.path}/log.txt");
  try {
    await filePath.writeAsString("$message\n ", mode: FileMode.append);
  } catch (e) {
    // print("error writing to a log file $e");
  }
}
