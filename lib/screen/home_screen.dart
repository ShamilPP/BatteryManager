import 'package:battery_manager/provider/battery_provider.dart';
import 'package:battery_manager/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'home/battery_capacity.dart';
import 'home/battery_health.dart';
import 'home/battery_progress.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
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
      appBar: AppBar(
        title: Text(
          "Battery manager",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
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

            // TODO: Advance Battery Details
            Positioned(
              bottom: MediaQuery.of(context).size.height / 13,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BatteryCapacity(),
                    BatteryHealth(),
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
      Provider.of<BatteryProvider>(context, listen: false).maxCharge = max;
      Provider.of<BatteryProvider>(context, listen: false).music = path;
      Provider.of<BatteryProvider>(context, listen: false).time = time;
      Provider.of<BatteryProvider>(context, listen: false).batteryCapacity =
          batteryCapacity;
      Provider.of<BatteryProvider>(context, listen: false).batteryHealth =
          batteryHealth;
      Provider.of<BatteryProvider>(context, listen: false).temperature =
          temperature;
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