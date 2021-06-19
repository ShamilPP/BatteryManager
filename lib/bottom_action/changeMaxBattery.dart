import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeMaxBattery extends StatefulWidget {
  @override
  _ChangeMaxBatteryState createState() => _ChangeMaxBatteryState();
}

class _ChangeMaxBatteryState extends State<ChangeMaxBattery>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

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
        width: 100,
        height: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 3,
                color: Color(Provider.of<MyProvider>(context, listen: false)
                    .primaryColor))),
        child: InkWell(
          splashColor:
              Color(Provider.of<MyProvider>(context, listen: false).fontColor),
          onTap: () {
            Provider.of<MyProvider>(context, listen: false)
                .changeMaxBattery(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.battery_full_outlined,
                size: 50,
                color: Colors.green,
              ),
              Text(
                "Max charge",
                maxLines: 1,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(Provider.of<MyProvider>(context, listen: false)
                        .fontColor)),
              ),
              Text(
                Provider.of<MyProvider>(context, listen: false)
                        .maxCharge
                        .toString() +
                    " %",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(Provider.of<MyProvider>(context, listen: false)
                        .fontColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
