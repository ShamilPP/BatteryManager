import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:goodone_widgets/SlideInWidget.dart';
import 'package:provider/provider.dart';

class MusicChange extends StatefulWidget {
  @override
  _MusicChangeState createState() => _MusicChangeState();
}

class _MusicChangeState extends State<MusicChange> {
  @override
  Widget build(BuildContext context) {
    return SlideInWidget(
      delay: 1500,
      duration: 1000,
      child: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Battery health",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(Provider.of<MyProvider>(context, listen: false)
                      .fontColor)),
            ),
            Text(
              Provider.of<MyProvider>(context, listen: false).batteryHealth,
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
