import 'package:battery_manager/provider/battery_provider.dart';
import 'package:battery_manager/public/dialog.dart';
import 'package:battery_manager/screen/settings/change_alarm_time.dart';
import 'package:battery_manager/screen/update_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goodone_widgets/goodone_widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  static const platform = const MethodChannel('battery');

  @override
  Widget build(BuildContext context) {
    if (Provider.of<BatteryProvider>(context, listen: false).music !=
        "Default ( Ring tone )") {
      String fileNameWithExt =
          Provider.of<BatteryProvider>(context, listen: false)
              .music
              .split('/')
              .last;
      Provider.of<BatteryProvider>(context, listen: false).music =
          fileNameWithExt.split('.').first;
    }

    int maxCharge =
        Provider.of<BatteryProvider>(context, listen: false).maxCharge;
    String music = Provider.of<BatteryProvider>(context, listen: false).music;
    String time = Provider.of<BatteryProvider>(context, listen: false).time;
    if (time != "Unlimited") {
      int millisecond = int.parse(time);
      int minutes = millisecond ~/ 60000;
      time = minutes.toString() + " Minute";
    }

    List<String> settingsOption = [
      "Max Charge",
      "Music",
      "Alarm time",
      "Check for Update",
      "About"
    ];
    List<String> settingsSubOption = [
      maxCharge.toString(),
      music,
      time,
      "Update to latest version",
      "Developer : Shamil"
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.green,
          actions: [
            TextButton.icon(
              onPressed: () {
                dialog(
                    context,
                    "Stop service",
                    'Open the app to restart the service\n\n\nHOW TO STOP SERVICE\n---------------------------------------\n1. Click "STOP"\n2. Click "Force Stop"\n3. Click "Ok"',
                    "STOP", () {
                  openAppSettings();
                });
              },
              icon: Icon(
                Icons.stop,
                color: Colors.red,
                size: 30,
              ),
              label: Text(
                "STOP",
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.white),
          )),
      body: Container(
        child: ListView.separated(
          itemCount: settingsOption.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(thickness: 1, color: Colors.green);
          },
          itemBuilder: (BuildContext context, int index) {
            return SlideInWidget(
              delay: index * 200,
              duration: 500,
              child: ListTile(
                title: Text(
                  settingsOption[index],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
                subtitle: Text(
                  settingsSubOption[index],
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                onTap: () {
                  if (index == 0) {
                    changeMaxBattery();
                  } else if (index == 1) {
                    pickAndSet();
                  } else if (index == 2) {
                    changeAlarmTime(context);
                  } else if (index == 3) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => CheckForUpdate()));
                  } else if (index == 4) {
                    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                      String version = packageInfo.version;

                      Fluttertoast.showToast(
                          msg: "App version : " + version,
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void changeAlarmTime(BuildContext buildContext) {
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Select Alarm time',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  AlarmTime(),
                ],
              ),
            ),
          );
        });
  }

  void setMax(String text) async {
    int charge = int.parse(text);
    await platform.invokeMethod("setMax", {"charge": charge});
  }

  // Change Music

  void pickAndSet() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      String path = result.files.single.path.toString();
      Provider.of<BatteryProvider>(context, listen: false).setMusic(path);
      await platform.invokeMethod("setMusic", {"path": path});
    } else {
      // User canceled the picker
    }
  }

  // Change max battery
  changeMaxBattery() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        TextEditingController controller = new TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Set max charge',
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.green),
                        borderRadius: BorderRadius.circular(30)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.green),
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Enter your max charge",
                    hintStyle: TextStyle(fontSize: 17, color: Colors.green),
                  ),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                try {
                  if (controller.text != "") {
                    int charge = int.parse(controller.text);
                    if (charge <= 100) {
                      if (charge > 2) {
                        setMax(controller.text);
                        Navigator.pop(context);
                        Provider.of<BatteryProvider>(context, listen: false)
                            .setMaxCharge(charge);
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
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
