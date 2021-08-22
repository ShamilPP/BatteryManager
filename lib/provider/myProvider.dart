import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProvider extends ChangeNotifier {
  static const platform = const MethodChannel('battery');
  int primaryColor = Colors.blue.value;
  int backgroundColor = Colors.white.value;
  int fontColor = Colors.black.value;
  int maxCharge = 0;
  String music = "music";
  String batteryMAH = "10 mAh";
  String batteryHealth = "GOOD";
  SharedPreferences? sharedPreferences;

  void setPrimaryColor(int color) {
    primaryColor = color;
    notifyListeners();
  }

  void setBackgroundColor(int color) {
    backgroundColor = color;
    notifyListeners();
  }

  void setFontColor(int color) {
    fontColor = color;
    notifyListeners();
  }
  dialog(BuildContext buildContext, String title, String subTitle,
      String buttonText, void Function() clicked) {
    return showDialog<void>(
      context: buildContext,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(backgroundColor),
          title: Text(
            title,
            style: TextStyle(color: Color(fontColor)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  subTitle,
                  style: TextStyle(color: Color(fontColor)),
                )
              ],
            ),
          ),
          actions: [
            MaterialButton(
                color: Color(primaryColor),
                onPressed: clicked,
                child: Text(
                  buttonText,
                  style: TextStyle(color: Color(fontColor)),
                ))
          ],
        );
      },
    );
  }

  // Change Theme
  void changeColor(String provider, Color changedColor) {
    if (provider == "Primary") {
      setPrimaryColor(changedColor.value);
    } else if (provider == "Background") {
      setBackgroundColor(changedColor.value);
    } else if (provider == "Font") {
      setFontColor(changedColor.value);
    }
    notifyListeners();
  }

  selectColor(BuildContext buildContext, String provider) {
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select $provider color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: provider == "Primary"
                  ? Color(primaryColor)
                  : provider == "Background"
                      ? Color(backgroundColor)
                      : Color(fontColor),
              onColorChanged: (changedColor) {
                changeColor(provider, changedColor);
              },
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  if (provider == "Primary") {
                    sharedPreferences!.setInt(provider, primaryColor);
                  } else if (provider == "Background") {
                    sharedPreferences!.setInt(provider, backgroundColor);
                  }
                  if (provider == "Font") {
                    sharedPreferences!.setInt(provider, fontColor);
                  }
                  Navigator.pop(context);
                },
                child: Text("Select"))
          ],
        );
      },
    );
  }

  void selectColorType(BuildContext buildContext) {
    showDialog<void>(
      context: buildContext,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(backgroundColor),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      selectColor(context, "Primary");
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Primary color",
                          style: TextStyle(color: Color(fontColor)),
                        ))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      selectColor(context, "Background");
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Background color",
                            style: TextStyle(color: Color(fontColor))))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      selectColor(context, "Font");
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Font color",
                            style: TextStyle(color: Color(fontColor))))),
              ],
            ),
          ),
        );
      },
    );
  }

  setMaxCharge(int charge) {
    maxCharge = charge;
    notifyListeners();
  }

  void setMusic(String path) {
    music=path;
    notifyListeners();
  }
}
