import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class BatteryProgress extends StatefulWidget {
  final int batteryCharge;

  BatteryProgress(this.batteryCharge);

  @override
  _BatteryProgressState createState() => _BatteryProgressState();
}

class _BatteryProgressState extends State<BatteryProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

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
      duration: Duration(seconds: 2),
      builder: (context, value, child) {
        double? progress = double.tryParse(value.toString());
        double percentageWithDouble = progress! * 100;
        int? percentage = percentageWithDouble.toInt();

        return SlideTransition(
          position: offset,
          child: CircularPercentIndicator(
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Color(
                Provider.of<MyProvider>(context, listen: false).primaryColor),
            radius: MediaQuery.of(context).size.width - 100,
            lineWidth: 20.0,
            percent: progress,
            center: Text(
              "$percentage %",
              style: TextStyle(
                fontSize: 50,
                fontFamily: "Font",
                letterSpacing: 5,
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor),
              ),
            ),
          ),
        );
      },
    );
  }
}
