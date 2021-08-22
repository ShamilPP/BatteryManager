import 'package:battery_manager/page/settings.dart';
import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenSettings extends StatefulWidget {
  const OpenSettings({Key? key}) : super(key: key);

  @override
  _OpenSettingsState createState() => _OpenSettingsState();
}

class _OpenSettingsState extends State<OpenSettings>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    offset = Tween<Offset>(begin: Offset(0.0, -4.0), end: Offset.zero)
        .animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<MyProvider>(context, listen: false).music !=
        "Default ( Ring toon )") {
      String fileNameWithExt =
          Provider.of<MyProvider>(context, listen: false).music.split('/').last;
      Provider.of<MyProvider>(context, listen: false).music =
          fileNameWithExt.split('.').first;
    }
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
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListSettings()),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.settings,
                size: 50,
                color: Colors.deepOrange,
              ),
              Text(
                "Settings",
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
