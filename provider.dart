import 'package:flutter/cupertino.dart';

class update with ChangeNotifier {
  String text = "";
  String change_value = "";
  var list = [];
  ref() {
    text = text;
    list = list;
    change_value = change_value;
    notifyListeners();
  }

  notifyListeners();
}
