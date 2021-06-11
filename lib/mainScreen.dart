import 'package:battery_manager/changes/changeMaxBattery.dart';
import 'package:battery_manager/changes/musicChange.dart';
import 'package:battery_manager/changes/theme.dart';
import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int batteryCharge = 1;
  static const platform = const MethodChannel('battery');

  @override
  void initState() {
    super.initState();
    getAllBatteryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(Provider.of<MyProvider>(context, listen: true).backgroundColor),
      appBar: AppBar(
          backgroundColor: Color(
              Provider.of<MyProvider>(context, listen: false).primaryColor),
          title: Text(
            "Battery manager",
            style: TextStyle(
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor)),
          )),
      body: Container(
        child: Stack(
          children: [
            Positioned(
              right: MediaQuery.of(context).size.width -
                  MediaQuery.of(context).size.width +
                  50,
              top: 50,
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                height: MediaQuery.of(context).size.width - 100,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: MediaQuery.of(context).size.width - 100,
                      child: CircularProgressIndicator(
                        color: Color(
                            Provider.of<MyProvider>(context, listen: false)
                                .primaryColor),
                        strokeWidth: 15,
                        value: batteryCharge / 100,
                      ),
                    ),
                    Center(
                      child: Text(
                        "$batteryCharge %",
                        style: TextStyle(
                            fontSize: 50,
                            fontFamily: "Font",
                            color: Color(
                                Provider.of<MyProvider>(context, listen: false)
                                    .fontColor)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 13,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChangeMxBattery(),
                    MusicChange(),
                    ChangeTheme(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getAllBatteryInfo() async {
    int batteryLevel;
    int? max;
    String? path;

    try {
      batteryLevel = await platform.invokeMethod('getBatteryLevel');
      max = await platform.invokeMethod('getMax');
      path = await platform.invokeMethod('getMusic');
    } on PlatformException {
      batteryLevel = 100;
    }

    setState(() {
      batteryCharge = batteryLevel;
      Provider.of<MyProvider>(context, listen: false).maxCharge = max!;
      Provider.of<MyProvider>(context, listen: false).music = path!;
    });
  }
}