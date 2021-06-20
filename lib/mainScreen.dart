import 'package:battery_manager/batteryProgress.dart';
import 'package:battery_manager/bottom_action/batteryCapacity.dart';
import 'package:battery_manager/bottom_action/batteryHealth.dart';
import 'package:battery_manager/bottom_action/openSettings.dart';
import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
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
              child: BatteryProgress(batteryCharge),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 13,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChangeMaxBattery(),
                    OpenSettings(),
                    MusicChange(),
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
    String? batteryMAH;
    String? batteryHealth;

    try {
      batteryLevel = await platform.invokeMethod('getBatteryLevel');
      max = await platform.invokeMethod('getMax');
      path = await platform.invokeMethod('getMusic');
      batteryMAH = await platform.invokeMethod('getMAH');
      batteryHealth = await platform.invokeMethod('getHealth');
    } on PlatformException {
      batteryLevel = 100;
    }

    setState(() {
      batteryCharge = batteryLevel;
      Provider.of<MyProvider>(context, listen: false).maxCharge = max!;
      Provider.of<MyProvider>(context, listen: false).music = path!;
      Provider.of<MyProvider>(context, listen: false).batteryMAH = batteryMAH!;
      Provider.of<MyProvider>(context, listen: false).batteryHealth =
          batteryHealth!;
    });
  }
}
