import 'package:file_picker/file_picker.dart';
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

  // Change max battery
  changeMaxBattery(BuildContext buildContext) {
    return showDialog<void>(
      context: buildContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        TextEditingController controller = new TextEditingController();
        return AlertDialog(
          backgroundColor: Color(backgroundColor),
          title: Text(
            'Set max charge',
            style: TextStyle(color: Color(fontColor)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(primaryColor)),
                        borderRadius: BorderRadius.circular(30)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(primaryColor)),
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Enter your max charge",
                    hintStyle:
                        TextStyle(fontSize: 17, color: Color(primaryColor)),
                  ),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(fontColor)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(primaryColor)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              color: Color(primaryColor),
              onPressed: () {
                try {
                  if (controller.text != "") {
                    int charge = int.parse(controller.text);
                    if (charge <= 100) {
                      if (charge > 2) {
                        setMax(controller.text);
                        Navigator.pop(context);
                        maxCharge = charge;
                        notifyListeners();
                      } else {
                        dialog(context, "Wrong", "This is not supported", "OK",
                            () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      }
                    } else {
                      dialog(context, "Wrong", "This is not supported", "OK",
                          () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    dialog(context, "Wrong", "This is not supported", "OK", () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }
                } on Exception {
                  dialog(context, "Wrong", "This is not supported", "OK", () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }
              },
              child: Text(
                'Set',
                style: TextStyle(color: Color(fontColor)),
              ),
            ),
          ],
        );
      },
    );
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

  void setMax(String text) async {
    int charge = int.parse(text);
    await platform.invokeMethod("setMax", {"charge": charge});
  }

  // Change Music

  void pickAndSet(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      String path = result.files.single.path.toString();
      music = path;
      notifyListeners();
      await platform.invokeMethod("setMusic", {"path": path});
    } else {
      // User canceled the picker
    }
  }

  // Change Theme

  void changeColor(String provider, Color changedColor) {
    if (provider == "Primary") {
      setPrimaryColor(changedColor.value);
    } else if (provider == "Background") {
      setBackgroundColor(changedColor.value);
    }
    if (provider == "Font") {
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
}
