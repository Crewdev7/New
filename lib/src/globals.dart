import 'package:flutter/material.dart';

const appName = "Passy";
const appTitle = "Passy Password Manager";
const version = "0.1";
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
    default:
      return const Icon(Icons.verified_user_sharp);
  }
}

enum PasswordType {
  email,
  website,
  username,
  android,
  ios,
}

class PasswordData {
  String password;
  String title;
  String username;
  PasswordType passwordType;
  DateTime createdAt;
  int passwordLength;

  PasswordData({
    required this.title,
    required this.username,
    required this.password,
    required this.passwordType,
    required this.createdAt,
    required this.passwordLength,
  });
}
