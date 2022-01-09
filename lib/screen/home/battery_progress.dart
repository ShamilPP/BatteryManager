import 'package:battery_manager/provider/battery_provider.dart';
import 'package:flutter/material.dart';
import 'package:goodone_widgets/SlideInWidget.dart';
import 'package:goodone_widgets/helper.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

class BatteryProgress extends StatefulWidget {
  final int batteryCharge;

  BatteryProgress(this.batteryCharge);

  @override
  _BatteryProgressState createState() => _BatteryProgressState();
}

class _BatteryProgressState extends State<BatteryProgress> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: widget.batteryCharge / 100),
      duration: Duration(seconds: 5),
      builder: (context, value, child) {
        double progress = double.tryParse(value.toString());
        double percentageWithDouble = progress * 100;
        int percentage = percentageWithDouble.toInt();
        return SlideInWidget(
          delay: 500,
          duration: 2000,
          child: Container(
            width: MediaQuery.of(context).size.width - 100,
            height: MediaQuery.of(context).size.width - 100,
            child: LiquidCircularProgressIndicator(
              value: progress,
              valueColor: AlwaysStoppedAnimation(Colors.deepPurpleAccent),
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              borderWidth: 5.0,
              direction: Axis.vertical,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$percentage %",
                    style: TextStyle(
                      fontSize: 60,
                      fontFamily: "Font",
                      letterSpacing: 5,
                      color: Colors.black,
                    ),
                  ),
                  verticalSpace(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.thermostat,
                        size: 50,
                        color: Colors.red,
                      ),
                      Text(
                        Provider.of<BatteryProvider>(context, listen: false)
                            .temperature,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
