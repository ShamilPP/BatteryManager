import 'package:battery_manager/batteryProgress.dart';
import 'package:battery_manager/bottom_action/batteryCapacity.dart';
import 'package:battery_manager/bottom_action/batteryHealth.dart';
import 'package:battery_manager/page/settings.dart';
import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
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
    checkPermission();
    getAllBatteryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(Provider.of<MyProvider>(context, listen: true).backgroundColor),
      appBar: AppBar(
        backgroundColor:
            Color(Provider.of<MyProvider>(context, listen: false).primaryColor),
        title: Text(
          "Battery manager",
          style: TextStyle(
              color: Color(Provider.of<MyProvider>(context, listen: false)
                  .backgroundColor)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Color(Provider.of<MyProvider>(context, listen: false)
                  .backgroundColor),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            ),
          ),
        ],
      ),
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
    int max;
    String path;
    String time;
    String batteryCapacity;
    String batteryHealth;
    String temperature;

    try {
      batteryLevel = await platform.invokeMethod('getBatteryLevel');
      max = await platform.invokeMethod('getMax');
      path = await platform.invokeMethod('getMusic');
      time = await platform.invokeMethod('getTime');
      batteryCapacity = await platform.invokeMethod('getCapacity');
      batteryHealth = await platform.invokeMethod('getHealth');
      temperature = await platform.invokeMethod('getTemperature');
    } on PlatformException {
      batteryLevel = 100;
    }

    setState(() {
      batteryCharge = batteryLevel;
      Provider.of<MyProvider>(context, listen: false).maxCharge = max;
      Provider.of<MyProvider>(context, listen: false).music = path;
      Provider.of<MyProvider>(context, listen: false).time = time;
      Provider.of<MyProvider>(context, listen: false).batteryCapacity = batteryCapacity;
      Provider.of<MyProvider>(context, listen: false).batteryHealth =
          batteryHealth;
      Provider.of<MyProvider>(context, listen: false).temperature = temperature;
    });
  }

  Future<void> checkPermission() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.systemAlertWindow.isDenied) {
     await Permission.systemAlertWindow.request();
    }
  }
}
