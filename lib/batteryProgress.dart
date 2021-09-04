import 'package:battery_manager/provider/myProvider.dart';
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
              valueColor: AlwaysStoppedAnimation(
                  Color(Provider.of<MyProvider>(context).primaryColor)),
              backgroundColor:
                  Color(Provider.of<MyProvider>(context).backgroundColor),
              borderColor: Color(Provider.of<MyProvider>(context).fontColor),
              borderWidth: 5.0,
              direction: Axis.vertical,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$percentage %",
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: "Font",
                      letterSpacing: 5,
                      color: Color(Provider.of<MyProvider>(context, listen: false)
                          .fontColor),
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
                      ), Text(
                        Provider.of<MyProvider>(context, listen: false)
                            .temperature,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(Provider.of<MyProvider>(context, listen: false)
                              .fontColor),
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
