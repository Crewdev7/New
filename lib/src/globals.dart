const appName = "Passy";
const appTitle = "Passy Password Manager";
const version = "0.1";
const author = "CrewD";
const description = "This app is for managing passwords  safely";
const license = "Opensource";
const githubUrl = "githubUrl";
const website = "mysite";

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
