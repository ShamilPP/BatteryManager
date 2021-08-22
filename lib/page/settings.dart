import 'package:battery_manager/page/changeAlarmTime.dart';
import 'package:battery_manager/provider/myProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodone_widgets/goodone_widgets.dart';
import 'package:provider/provider.dart';

class ListSettings extends StatefulWidget {
  const ListSettings({Key key}) : super(key: key);

  @override
  _ListSettingsState createState() => _ListSettingsState();
}

class _ListSettingsState extends State<ListSettings>
    with SingleTickerProviderStateMixin {
  static const platform = const MethodChannel('battery');
  @override
  Widget build(BuildContext context) {
    int maxCharge = Provider.of<MyProvider>(context, listen: false).maxCharge;
    String music = Provider.of<MyProvider>(context, listen: false).music;

    List<String> settingsOption = [
      "Max Charge",
      "Music",
      "Theme",
      "Alarm time",
      "About"
    ];
    List<String> settingsSubOption = [
      maxCharge.toString(),
      music,
      "Custom Theme",
      "Alarm time",
      "Developer : Shamil"
    ];

    return Scaffold(
      backgroundColor:
      Color(Provider.of<MyProvider>(context, listen: true).backgroundColor),
      appBar: AppBar(
          backgroundColor: Color(
              Provider.of<MyProvider>(context, listen: false).primaryColor),
          title: Text(
            "Settings",
            style: TextStyle(
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor)),
          )),
      body: Container(
        child: ListView.separated(
          itemCount: settingsOption.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
                thickness: 1,
                color: Color(Provider.of<MyProvider>(context, listen: false)
                    .primaryColor));
          },
          itemBuilder: (BuildContext context, int index) {
            return SlideInWidget(
              delay: 100,
              child: ListTile(
                title: Text(
                  settingsOption[index],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(Provider.of<MyProvider>(context, listen: false)
                          .fontColor)),
                ),
                subtitle: Text(
                  settingsSubOption[index],
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(
                            Provider.of<MyProvider>(context, listen: false)
                                .fontColor)),
                  ),
                  onTap: () {
                    if (index == 0) {
                    changeMaxBattery();
                  } else if (index == 1) {
                    pickAndSet();
                  } else if (index == 2) {
                    Provider.of<MyProvider>(context, listen: false)
                        .selectColorType(context);
                  } else if (index == 3) {
                    changeAlarmTime(context);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void changeAlarmTime(BuildContext buildContext) {
    showDialog(
        context: buildContext,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(
                Provider.of<MyProvider>(context, listen: false)
                    .backgroundColor),
            title: Text(
              'Select Alarm time',
              style: TextStyle(
                color: Color(
                    Provider.of<MyProvider>(context, listen: false).fontColor),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ChangeAlarmTime(),
                ],
              ),
            ),
          );
        });
  }

  void setMax(String text) async {
    int charge = int.parse(text);
    await platform.invokeMethod("setMax", {"charge": charge});
  }

  // Change Music

  void pickAndSet() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      String path = result.files.single.path.toString();
      Provider.of<MyProvider>(context, listen: false).setMusic(path);
      await platform.invokeMethod("setMusic", {"path": path});
    } else {
      // User canceled the picker
    }
  }

  // Change max battery
  changeMaxBattery() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        TextEditingController controller = new TextEditingController();
        return AlertDialog(
          backgroundColor:
              Color(Provider.of<MyProvider>(context).backgroundColor),
          title: Text(
            'Set max charge',
            style: TextStyle(
                color: Color(Provider.of<MyProvider>(context).fontColor)),
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
                                Provider.of<MyProvider>(context).primaryColor)),
                        borderRadius: BorderRadius.circular(30)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2,
                            color: Color(
                                Provider.of<MyProvider>(context).primaryColor)),
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Enter your max charge",
                    hintStyle: TextStyle(
                        fontSize: 17,
                        color: Color(
                            Provider.of<MyProvider>(context).primaryColor)),
                  ),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(Provider.of<MyProvider>(context).fontColor)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color:
                        Color(Provider.of<MyProvider>(context).primaryColor)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              color: Color(Provider.of<MyProvider>(context).primaryColor),
              onPressed: () {
                try {
                  if (controller.text != "") {
                    int charge = int.parse(controller.text);
                    if (charge <= 100) {
                      if (charge > 2) {
                        setMax(controller.text);
                        Navigator.pop(context);
                        Provider.of<MyProvider>(context,listen: false).setMaxCharge(charge);
                      } else {
                        Provider.of<MyProvider>(context,listen: false).dialog(
                            context, "Wrong", "This is not supported", "OK",
                            () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      }
                    } else {
                      Provider.of<MyProvider>(context,listen: false).dialog(
                          context, "Wrong", "This is not supported", "OK", () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    Provider.of<MyProvider>(context,listen: false).dialog(
                        context, "Wrong", "This is not supported", "OK", () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }
                } on Exception {
                  Provider.of<MyProvider>(context,listen: false).dialog(
                      context, "Wrong", "This is not supported", "OK", () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }
              },
              child: Text(
                'Set',
                style: TextStyle(
                    color: Color(Provider.of<MyProvider>(context).fontColor)),
              ),
            ),
          ],
        );
      },
    );
  }
}
