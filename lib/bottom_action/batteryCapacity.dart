import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeMaxBattery extends StatefulWidget {
  @override
  _ChangeMaxBatteryState createState() => _ChangeMaxBatteryState();
}

class _ChangeMaxBatteryState extends State<ChangeMaxBattery>
    with SingleTickerProviderStateMixin {
   AnimationController controller;
   Animation<Offset> offset;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    offset = Tween<Offset>(begin: Offset(4.0, 0.0), end: Offset.zero)
        .animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offset,
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
                  color: Color(Provider.of<MyProvider>(context, listen: false)
                      .fontColor)),
            ),
            Text(
              Provider.of<MyProvider>(context, listen: false).batteryMAH,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(Provider.of<MyProvider>(context, listen: false)
                      .fontColor)),
            ),
          ],
        ),
      ),
    );
  }
}
