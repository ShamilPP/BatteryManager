import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryProvider extends ChangeNotifier {
  static const platform = const MethodChannel('battery');
  int fontColor = Colors.black.value;
  int maxCharge = 0;
  String music = "music";
  String time = "Unlimited";
  String batteryCapacity = "10 mAh";
  String batteryHealth = "10 %";
  String temperature = "0 °C";

  setMaxCharge(int charge) {
    maxCharge = charge;
    notifyListeners();
  }

  void setMusic(String path) {
    music = path;
    notifyListeners();
  }

  void setTime(String minute) {
    time = minute;
    notifyListeners();
  }
}
