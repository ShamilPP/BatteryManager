import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProvider extends ChangeNotifier {
  int primaryColor = Colors.blue.value;
  int backgroundColor = Colors.white.value;
  int fontColor = Colors.black.value;
  int maxCharge = 0;
  String music = "music";
  SharedPreferences? sharedPreferences;
}
