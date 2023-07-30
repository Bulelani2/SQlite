import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class UnitData with ChangeNotifier {
  Map<String, dynamic> _map = {};
  bool _error = false;
  String _errormessage = "";
  int _unitnum = 0;
  int len = 0;

  int get unitnum => _unitnum;

  set unitnum(int unitnum) {
    _unitnum = unitnum;
    notifyListeners();
  }

  Map<String, dynamic> get map => _map;
  bool get error => _error;
  String get errormessage => _errormessage;

  Future<void> get fetchData async {
    final response = await get(
      Uri.parse(
          "https://dl.dropboxusercontent.com/s/q6chvs5eqktd1nb/unitReflections.json?dl=0"),
    );
    if (response.statusCode == 200) {
      try {
        _map = jsonDecode(response.body);
        _error = false;
      } catch (e) {
        _error = true;
        _errormessage = e.toString();
        _map = {};
        _unitnum = 0;
      }
    } else {
      _error = true;
      _errormessage = 'Error: No Internet Connection :) !!';
      _map = {};
      _unitnum = 0;
    }

    notifyListeners();
  }

  void initialValue() {
    _map = {};
    _error = false;
    _errormessage = "";
    _unitnum = 0;
    notifyListeners();
  }
}
