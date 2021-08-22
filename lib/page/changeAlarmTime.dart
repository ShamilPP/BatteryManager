import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeAlarmTime extends StatefulWidget {
  @override
  _ChangeAlarmTimeState createState() => _ChangeAlarmTimeState();
}

enum CustomAlarm { unlimited, custom }

class _ChangeAlarmTimeState extends State<ChangeAlarmTime> {
  CustomAlarm customAlarm = CustomAlarm.unlimited;
  bool vis = false;
  TextEditingController customController = new TextEditingController();

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
                  customAlarm = value;
                  vis = false;
                });
              },
            ),
          ),
          onTap: () {
            setState(() {
              customAlarm = CustomAlarm.unlimited;
              vis = false;
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
                  customAlarm = value;
                  vis = true;
                });
              },
            ),
          ),
          onTap: () {
            setState(() {
              customAlarm = CustomAlarm.custom;
              vis = true;
            });
          },
        ),
        Visibility(
          visible: vis,
          child: Container(
            width: 150,
            child: TextField(
              style: TextStyle(
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor),
              ),
              cursorColor: Color(
                  Provider.of<MyProvider>(context, listen: false).fontColor),
              controller: customController,
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
                  hintText: "Second"),
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
              if (customController.text != "") {
                int second = int.parse(customController.text);
                if (second > 100 || second < 1) {
                  Provider.of<MyProvider>(context, listen: false).dialog(
                      context, "Error", "This is not supported", "OK", () {
                    Navigator.pop(context);
                  });
                } else {
                  Provider.of<MyProvider>(context, listen: false).dialog(
                      context,
                      "Coming soon !",
                      "Next update will coming soon",
                      'Wait', () {
                    Navigator.pop(context);
                  });
                }
              } else {
                Provider.of<MyProvider>(context, listen: false).dialog(
                    context, "Error", "This is not supported", "OK", () {
                  Navigator.pop(context);
                });
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
}
