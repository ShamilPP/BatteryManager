import 'package:battery_manager/provider/battery_provider.dart';
import 'package:battery_manager/public/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AlarmTime extends StatefulWidget {
  @override
  _AlarmTimeState createState() => _AlarmTimeState();
}

enum CustomAlarm { unlimited, custom }

class _AlarmTimeState extends State<AlarmTime> {
  CustomAlarm customAlarm = CustomAlarm.unlimited;
  bool customVisibility = false;
  TextEditingController timeTextController = new TextEditingController();
  String time = "Unlimited";
  static const platform = const MethodChannel('battery');

  @override
  void initState() {
    time = Provider.of<BatteryProvider>(context, listen: false).time;
    if (time != "Unlimited") {
      customAlarm = CustomAlarm.custom;
      customVisibility = true;
      int millisecond = int.parse(time);
      int minutes = (millisecond ~/ 60000);
      timeTextController.text = minutes.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            'Unlimited',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.green,
            ),
            child: Radio<CustomAlarm>(
              activeColor: Colors.green,
              value: CustomAlarm.unlimited,
              groupValue: customAlarm,
              onChanged: (CustomAlarm value) {
                setState(() {
                  customAlarm = CustomAlarm.unlimited;
                  customVisibility = false;
                  print("un");
                });
              },
            ),
          ),
          onTap: () {
            setState(() {
              customAlarm = CustomAlarm.unlimited;
              customVisibility = false;
            });
          },
        ),
        ListTile(
          title: Text(
            "Custom",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.green,
            ),
            child: Radio<CustomAlarm>(
              activeColor: Colors.green,
              value: CustomAlarm.custom,
              groupValue: customAlarm,
              onChanged: (CustomAlarm value) {
                setState(() {
                  customAlarm = CustomAlarm.custom;
                  customVisibility = true;
                  print("no");
                });
              },
            ),
          ),
          onTap: () {
            setState(() {
              customAlarm = CustomAlarm.custom;
              customVisibility = true;
            });
          },
        ),
        Visibility(
          visible: customVisibility,
          child: Container(
            width: 150,
            child: TextField(
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              cursorColor: Colors.black,
              controller: timeTextController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.green,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: "Minute"),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: MaterialButton(
            color: Colors.green,
            onPressed: () {
              if (customAlarm == CustomAlarm.unlimited) {
                Navigator.pop(context);
                Provider.of<BatteryProvider>(context, listen: false)
                    .setTime("Unlimited");
                platform.invokeMethod("setTime", {"time": "Unlimited"});
              } else {
                if (timeTextController.text != "") {
                  int minutes;
                  try {
                    minutes = int.parse(timeTextController.text);
                  } catch (e) {
                    minutes = 0;
                  }
                  if (minutes > 7 || minutes < 1) {
                    dialog(
                        context, "Error", Text("This is not supported"), "OK",
                        () {
                      Navigator.pop(context);
                    });
                  } else {
                    setTime();
                  }
                } else {
                  dialog(context, "Error", Text("This is not supported"), "OK",
                      () {
                    Navigator.pop(context);
                  });
                }
              }
            },
            child: Text(
              "Select",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
    );
  }

  void setTime() async {
    Navigator.pop(context);
    int minutes = int.parse(timeTextController.text);
    int millisecond = minutes * 60000;
    Provider.of<BatteryProvider>(context, listen: false)
        .setTime(millisecond.toString());
    platform.invokeMethod("setTime", {"time": millisecond.toString()});
  }
}
