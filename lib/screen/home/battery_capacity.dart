import 'package:battery_manager/provider/battery_provider.dart';
import 'package:flutter/material.dart';
import 'package:goodone_widgets/goodone_widgets.dart';
import 'package:provider/provider.dart';

class BatteryCapacity extends StatefulWidget {
  @override
  _BatteryCapacityState createState() => _BatteryCapacityState();
}

class _BatteryCapacityState extends State<BatteryCapacity> {
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
              Provider.of<BatteryProvider>(context, listen: false)
                  .batteryCapacity,
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
