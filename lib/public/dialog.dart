import 'package:flutter/material.dart';

dialog(BuildContext buildContext, String title, Widget subTitle,
    String buttonText, void Function() clicked) {
  showDialog(
    context: buildContext,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        content: subTitle,
        actions: [
          ElevatedButton(
              onPressed: clicked,
              child: Text(
                buttonText,
                style: TextStyle(color: Colors.white),
              ))
        ],
      );
    },
  );
}
