import 'package:flutter/material.dart';
import 'package:units_reflection/Database/reflction_database.dart';
import 'package:units_reflection/Models/user.dart';

class UserService with ChangeNotifier {
  late User _currentUser;
  bool _busyCreate = false;
  bool _userExist = false;

  User get currentUser => _currentUser;
  bool get busyCreate => _busyCreate;
  bool get userExist => _userExist;

  set userExist(bool value) {
    _userExist = value;
    notifyListeners();
  }

  Future<String> getUser(String username) async {
    String result = "OK";

    try {
      _currentUser = await ReflectionDatabase.instance.getUser(username);
      notifyListeners();
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future<String> checkUserExist(String username) async {
    String result = "OK";

    try {
      await ReflectionDatabase.instance.getUser(username);
      notifyListeners();
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future<String> updateUser(String name) async {
    String result = "OK";

    _currentUser.name = name;
    notifyListeners();
    try {
      await ReflectionDatabase.instance.updateUser(_currentUser);
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future<String> createUser(User user) async {
    String result = "OK";
    _busyCreate = true;
    notifyListeners();

    try {
      await ReflectionDatabase.instance.createUser(user);
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    _busyCreate = false;
    notifyListeners();
    return result;
  }
}

String getHumanReadableError(String message) {
  if (message.contains('UNIQUE constraint failed')) {
    return 'This user already exists in the database. Please choose a new one.';
  }
  if (message.contains('not found in the database')) {
    return 'The user does not exist in the database. Please register first.';
  }
  return message;
}
