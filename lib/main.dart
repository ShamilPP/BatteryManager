import 'package:battery_manager/mainScreen.dart';
import 'package:battery_manager/provider/myProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext providerContext) {
      return MyProvider();
    },
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    themeCreate(context);
    return MaterialApp(
      title: "Battery manager",
      home: MainScreen(),
    );
  }

  void themeCreate(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Provider.of<MyProvider>(context, listen: false).sharedPreferences =
        sharedPreferences;
    if (!sharedPreferences.containsKey("Primary")) {
      sharedPreferences.setInt("Primary", 4280391411);
      sharedPreferences.setInt("Background", 4294967295);
      sharedPreferences.setInt("Font", 4278190080);
      Provider.of<MyProvider>(context, listen: false).primaryColor = 4280391411;
      Provider.of<MyProvider>(context, listen: false).backgroundColor =
          4294967295;
      Provider.of<MyProvider>(context, listen: false).fontColor = 4278190080;
    } else {
      Provider.of<MyProvider>(context, listen: false).primaryColor =
          Provider.of<MyProvider>(context, listen: false)
              .sharedPreferences!
              .getInt("Primary")!;
      Provider.of<MyProvider>(context, listen: false).backgroundColor =
          Provider.of<MyProvider>(context, listen: false)
              .sharedPreferences!
              .getInt("Background")!;
      Provider.of<MyProvider>(context, listen: false).fontColor =
          Provider.of<MyProvider>(context, listen: false)
              .sharedPreferences!
              .getInt("Font")!;
    }
  }
}
