import 'package:flutter/material.dart';
import 'package:units_reflection/Database/reflction_database.dart';
import 'package:units_reflection/Models/reflection.dart';

class ReflectionService with ChangeNotifier {
  List<Reflection> _reflection = [];

  List<Reflection> get reflection => _reflection;

  Future<String> getReflections(String username) async {
    try {
      _reflection =
          await ReflectionDatabase.instance.getAllReflections(username);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return "OK";
  }

  Future<String> deleteReflections(Reflection reflection) async {
    try {
      await ReflectionDatabase.instance.deleteReflection(reflection);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    String results = await getReflections(reflection.username);
    return results;
  }

  Future<String> createReflections(Reflection reflection) async {
    try {
      await ReflectionDatabase.instance.createReflction(reflection);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    String results = await getReflections(reflection.username);
    return results;
  }
}
