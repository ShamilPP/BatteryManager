import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class ChangeTheme extends StatefulWidget {
  @override
  _ChangeThemeState createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
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
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(
                    Provider.of<MyProvider>(context, listen: false)
                        .backgroundColor),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selectColor("Primary");
                          },
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Primary color",
                                style: TextStyle(
                                    color: Color(Provider.of<MyProvider>(
                                            context,
                                            listen: false)
                                        .fontColor)),
                              ))),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selectColor("Background");
                          },
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Background color",
                                  style: TextStyle(
                                      color: Color(Provider.of<MyProvider>(
                                              context,
                                              listen: false)
                                          .fontColor))))),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selectColor("Font");
                          },
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Font color",
                                  style: TextStyle(
                                      color: Color(Provider.of<MyProvider>(
                                              context,
                                              listen: false)
                                          .fontColor))))),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 50,
              color: Colors.orange,
            ),
            Text(
              "Theme",
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

  void changeColor(String provider, Color changedColor) {
    setState(() {
      if (provider == "Primary") {
        Provider.of<MyProvider>(context, listen: false)
            .setPrimaryColor(changedColor.value);
      } else if (provider == "Background") {
        Provider.of<MyProvider>(context, listen: false)
            .setBackgroundColor(changedColor.value);
      }
      if (provider == "Font") {
        Provider.of<MyProvider>(context, listen: false)
            .setFontColor(changedColor.value);
      }
    });
  }

  selectColor(String provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select $provider color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: provider == "Primary"
                  ? Color(Provider.of<MyProvider>(context, listen: false)
                      .primaryColor)
                  : provider == "Background"
                      ? Color(Provider.of<MyProvider>(context, listen: false)
                          .backgroundColor)
                      : Color(Provider.of<MyProvider>(context, listen: false)
                          .fontColor),
              onColorChanged: (changedColor) {
                changeColor(provider, changedColor);
              },
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  if (provider == "Primary") {
                    Provider.of<MyProvider>(context, listen: false)
                        .sharedPreferences!
                        .setInt(
                            provider,
                            Provider.of<MyProvider>(context, listen: false)
                                .primaryColor);
                  } else if (provider == "Background") {
                    Provider.of<MyProvider>(context, listen: false)
                        .sharedPreferences!
                        .setInt(
                            provider,
                            Provider.of<MyProvider>(context, listen: false)
                                .backgroundColor);
                  }
                  if (provider == "Font") {
                    Provider.of<MyProvider>(context, listen: false)
                        .sharedPreferences!
                        .setInt(
                            provider,
                            Provider.of<MyProvider>(context, listen: false)
                                .fontColor);
                  }
                  Navigator.pop(context);
                },
                child: Text("Select"))
          ],
        );
      },
    );
  }
}
