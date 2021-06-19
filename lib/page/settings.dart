import 'package:battery_manager/page/changeAlarmTime.dart';
import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListSettings extends StatefulWidget {
  const ListSettings({Key? key}) : super(key: key);

  @override
  _ListSettingsState createState() => _ListSettingsState();
}

class _ListSettingsState extends State<ListSettings>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;
  bool rightORLeft = true;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    offset = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int maxCharge = Provider.of<MyProvider>(context, listen: false).maxCharge;
    String music = Provider.of<MyProvider>(context, listen: false).music;

    List<String> settingsOption = [
      "Max Charge",
      "Music",
      "Theme",
      "Alarm time",
      "About"
    ];
    List<String> settingsSubOption = [
      maxCharge.toString(),
      music,
      "Custom Theme",
      "Alarm time",
      "Developer : Shamil"
    ];

    return Scaffold(
      backgroundColor:
          Color(Provider.of<MyProvider>(context, listen: true).backgroundColor),
      appBar: AppBar(
          backgroundColor: Color(
              Provider.of<MyProvider>(context, listen: false).primaryColor),
          title: Text(
            "Settings",
            style: TextStyle(
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor)),
          )),
      body: Container(
        child: ListView.separated(
          itemCount: settingsOption.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
                thickness: 1,
                color: Color(Provider.of<MyProvider>(context, listen: false)
                    .primaryColor));
          },
          itemBuilder: (BuildContext context, int index) {
            if (rightORLeft) {
              offset = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
                  .animate(controller);
              rightORLeft = false;
            } else {
              offset = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero)
                  .animate(controller);
              rightORLeft = true;
            }
            controller.forward();
            Future.delayed(Duration(seconds: 1), () {});
            return SlideTransition(
              position: offset,
              child: ListTile(
                title: Text(
                  settingsOption[index],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(
                          Provider.of<MyProvider>(context, listen: false)
                              .fontColor)),
                ),
                subtitle: Text(
                  settingsSubOption[index],
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(
                          Provider.of<MyProvider>(context, listen: false)
                              .fontColor)),
                ),
                onTap: () {
                  if (index == 0) {
                    Provider.of<MyProvider>(context, listen: false)
                        .changeMaxBattery(context);
                  } else if (index == 1) {
                    Provider.of<MyProvider>(context, listen: false)
                        .pickAndSet(context);
                  } else if (index == 2) {
                    Provider.of<MyProvider>(context, listen: false)
                        .selectColorType(context);
                  } else if (index == 3) {
                    changeAlarmTime(context);
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
            backgroundColor: Color(
                Provider.of<MyProvider>(context, listen: false)
                    .backgroundColor),
            title: Text(
              'Select Alarm time',
              style: TextStyle(
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ChangeAlarmTime(),
                ],
              ),
            ),
          );
        });
  }
}
