import 'package:flutter/material.dart';

dialog(BuildContext buildContext, String title, String subTitle,
    String buttonText, void Function() clicked) {
  return showDialog<void>(
    context: buildContext,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                subTitle,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
        actions: [
          MaterialButton(
              color: Colors.green,
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