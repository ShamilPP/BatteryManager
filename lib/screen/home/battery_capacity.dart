import 'package:battery_manager/provider/battery_provider.dart';
import 'package:flutter/material.dart';
import 'package:goodone_widgets/goodone_widgets.dart';
import 'package:provider/provider.dart';

class ChangeMaxBattery extends StatefulWidget {
  @override
  _ChangeMaxBatteryState createState() => _ChangeMaxBatteryState();
}

class _ChangeMaxBatteryState extends State<ChangeMaxBattery> {
  @override
  Widget build(BuildContext context) {
    return SlideInWidget(
      delay: 500,
      duration: 1000,
      child: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Battery Capacity",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            Text(
              Provider.of<BatteryProvider>(context, listen: false).batteryCapacity,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
