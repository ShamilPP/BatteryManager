import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChangeMxBattery extends StatefulWidget {
  @override
  _ChangeMxBatteryState createState() => _ChangeMxBatteryState();
}

class _ChangeMxBatteryState extends State<ChangeMxBattery> {
  static const platform = const MethodChannel('battery');

  @override
  Widget build(BuildContext context) {
    return Container(
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
          changeMaxBattery();
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
    );
  }

  changeMaxBattery() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        TextEditingController controller = new TextEditingController();
        return AlertDialog(
          backgroundColor: Color(
              Provider.of<MyProvider>(context, listen: false).backgroundColor),
          title: Text(
            'Set max charge',
            style: TextStyle(
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2,
                            color: Color(
                                Provider.of<MyProvider>(context, listen: false)
                                    .primaryColor)),
                        borderRadius: BorderRadius.circular(30)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2,
                            color: Color(
                                Provider.of<MyProvider>(context, listen: false)
                                    .primaryColor)),
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Enter your max charge",
                    hintStyle: TextStyle(
                        fontSize: 17,
                        color: Color(
                            Provider.of<MyProvider>(context, listen: false)
                                .primaryColor)),
                  ),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(
                          Provider.of<MyProvider>(context, listen: false)
                              .fontColor)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Color(Provider.of<MyProvider>(context, listen: false)
                        .primaryColor)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              color: Color(
                  Provider.of<MyProvider>(context, listen: false).primaryColor),
              onPressed: () {
                try {
                  if (controller.text != "") {
                    int charge = int.parse(controller.text);
                    if (charge <= 100) {
                      if (charge > 2) {
                        setMax(controller.text);
                        Navigator.pop(context);
                        setState(() {
                          Provider.of<MyProvider>(context, listen: false)
                              .maxCharge = charge;
                        });
                      } else {
                        dialog("Wrong", "This is not supported", "OK", () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      }
                    } else {
                      dialog("Wrong", "This is not supported", "OK", () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    dialog("Wrong", "This is not supported", "OK", () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }
                } on Exception {
                  dialog("Wrong", "This is not supported", "OK", () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }
              },
              child: Text(
                'Set',
                style: TextStyle(
                    color: Color(Provider.of<MyProvider>(context, listen: false)
                        .fontColor)),
              ),
            ),
          ],
        );
      },
    );
  }

  dialog(String title, String subTitle, String buttonText,
      void Function() clicked) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  subTitle,
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(onPressed: clicked, child: Text(buttonText))
          ],
        );
      },
    );
  }

  void setMax(String text) async {
    int charge = int.parse(text);
    await platform.invokeMethod("setMax", {"charge": charge});
  }
}
