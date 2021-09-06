import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChangeAlarmTime extends StatefulWidget {
  @override
  _ChangeAlarmTimeState createState() => _ChangeAlarmTimeState();
}

enum CustomAlarm { unlimited, custom }

class _ChangeAlarmTimeState extends State<ChangeAlarmTime> {
  CustomAlarm customAlarm = CustomAlarm.unlimited;
  bool customVisibility = false;
  TextEditingController timeTextController = new TextEditingController();
  String time = "Unlimited";
  static const platform = const MethodChannel('battery');

  @override
  void initState() {
    time = Provider.of<MyProvider>(context, listen: false).time;
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
              color: Color(
                  Provider.of<MyProvider>(context, listen: false).fontColor),
            ),
          ),
          leading: Theme(
            data: ThemeData(
              unselectedWidgetColor: Color(
                  Provider.of<MyProvider>(context, listen: false).primaryColor),
            ),
            child: Radio<CustomAlarm>(
              activeColor: Color(
                  Provider.of<MyProvider>(context, listen: false).primaryColor),
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
              color: Color(
                  Provider.of<MyProvider>(context, listen: false).fontColor),
            ),
          ),
          leading: Theme(
            data: ThemeData(
              unselectedWidgetColor: Color(
                  Provider.of<MyProvider>(context, listen: false).primaryColor),
            ),
            child: Radio<CustomAlarm>(
              activeColor: Color(
                  Provider.of<MyProvider>(context, listen: false).primaryColor),
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
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor),
              ),
              cursorColor: Color(
                  Provider.of<MyProvider>(context, listen: false).fontColor),
              controller: timeTextController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(Provider.of<MyProvider>(context, listen: false)
                        .primaryColor),
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(
                              Provider.of<MyProvider>(context, listen: false)
                                  .primaryColor))),
                  hintStyle: TextStyle(
                    color: Color(Provider.of<MyProvider>(context, listen: false)
                        .fontColor),
                  ),
                  hintText: "Minute"),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: MaterialButton(
            color: Color(
                Provider.of<MyProvider>(context, listen: false).primaryColor),
            onPressed: () {
              if (customAlarm == CustomAlarm.unlimited) {
                Navigator.pop(context);
                Provider.of<MyProvider>(context, listen: false)
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
                    Provider.of<MyProvider>(context, listen: false).dialog(
                        context, "Error", "This is not supported", "OK", () {
                      Navigator.pop(context);
                    });
                  } else {
                    setTime();
                  }
                } else {
                  Provider.of<MyProvider>(context, listen: false).dialog(
                      context, "Error", "This is not supported", "OK", () {
                    Navigator.pop(context);
                  });
                }
              }
            },
            child: Text(
              "Select",
              style: TextStyle(
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor),
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
    Provider.of<MyProvider>(context, listen: false)
        .setTime(millisecond.toString());
    platform.invokeMethod("setTime", {"time": millisecond.toString()});
  }
}
