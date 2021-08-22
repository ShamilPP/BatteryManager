import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

class BatteryProgress extends StatefulWidget {
  final int batteryCharge;

  BatteryProgress(this.batteryCharge);

  @override
  _BatteryProgressState createState() => _BatteryProgressState();
}

class _BatteryProgressState extends State<BatteryProgress>
    with SingleTickerProviderStateMixin {
   AnimationController controller;
   Animation<Offset> offset;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: widget.batteryCharge / 100),
      duration: Duration(seconds: 5),
      builder: (context, value, child) {
        double progress = double.tryParse(value.toString());
        double percentageWithDouble = progress * 100;
        int percentage = percentageWithDouble.toInt();
        return SlideTransition(
            position: offset,
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              height: MediaQuery.of(context).size.width - 100,
              child: LiquidCircularProgressIndicator(
                value: progress,
                // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Color(Provider.of<MyProvider>(context).primaryColor)),
                // valueColor: AlwaysStoppedAnimation(Colors.pink),
                // Defaults to the current Theme's accentColor.
                backgroundColor: Color(Provider.of<MyProvider>(context).backgroundColor),
                // Defaults to the current Theme's backgroundColor.
                borderColor: Color(Provider.of<MyProvider>(context).fontColor),
                borderWidth: 5.0,
                direction: Axis.vertical,
                // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                center: Text(
                  "$percentage %",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "Font",
                    letterSpacing: 5,
                    color: Color(Provider.of<MyProvider>(context, listen: false)
                        .fontColor),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
