import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goodone_widgets/goodone_widgets.dart';
import 'package:goodone_widgets/helper.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckForUpdate extends StatefulWidget {
  @override
  _CheckForUpdateState createState() => _CheckForUpdateState();
}

class _CheckForUpdateState extends State<CheckForUpdate> {
  bool progressVisible = false;
  bool updateAvailable = false;
  bool firstCheck = false;
  String updateLink = "No Update";
  double downloadProgress;
  String checkResultText = "";

  @override
  Widget build(BuildContext context) {
    checkInstallPermission();
    if (downloadProgress != null) {
      var percentage = downloadProgress * 100;
      checkResultText = percentage.toInt().toString() + " %";
    } else if (updateAvailable) {
      checkResultText = "Update is Available";
    } else {
      checkResultText = "Already Latest Version";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Check for Update'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                  visible: firstCheck,
                  child: Text(
                    checkResultText,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              verticalSpace(height: 10),
              Visibility(
                  visible: progressVisible,
                  child: SlideInWidget(
                    delay: 100,
                    duration: 200,
                    child: LinearProgressIndicator(
                      value: downloadProgress,
                      minHeight: 5,
                    ),
                  )),
              verticalSpace(height: 10),
              Visibility(
                visible: downloadProgress != null ? false : true,
                child: MyButton(
                  text: updateAvailable ? "Download" : "Check For Update",
                  defaults: MyButtonDefaults(
                      bgColor: updateAvailable ? Colors.red : Colors.green,
                      forecolor: Colors.white),
                  centerAlign: true,
                  onClick: () {
                    if (updateAvailable) {
                      _downloadUpdate(
                          updateLink);
                      setState(() {
                        progressVisible = true;
                      });
                    } else {
                      setState(() {
                        progressVisible = true;
                      });
                      checkUpdate();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkUpdate() async {
    String currentVersion;
    String latestVersion;
    CollectionReference version =
        FirebaseFirestore.instance.collection('version');
    version.doc("Afyc0wMQFQj2kkPuaZKM").get().then((value) {
      latestVersion = value.get("version");
      updateLink = value.get("link");
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        currentVersion = packageInfo.version;

        if (latestVersion == "1" || currentVersion == latestVersion) {
          setState(() {
            progressVisible = false;
            firstCheck = true;
          });
        } else {
          setState(() {
            updateAvailable = true;
            progressVisible = false;
            firstCheck = true;
          });
        }
      });
    });
  }

  _downloadUpdate(String url) async {
    int total = 0, received = 0;
    http.StreamedResponse response;
    final List<int> bytes = [];
    response = await http.Client().send(http.Request('GET', Uri.parse(url)));
    total = response.contentLength ?? 0;

    response.stream.listen((value) {
      if (this.mounted) {
        setState(() {
          bytes.addAll(value);
          received += value.length;
          downloadProgress = received / total;
        });
      }
    }).onDone(() async {
      final file = File('/storage/emulated/0/Download/Battery Manager.apk');
      await file.writeAsBytes(bytes);
      OpenFile.open(file.path);
    });
  }

  void checkInstallPermission() async {
    if (await Permission.requestInstallPackages.isDenied) {
      Permission.requestInstallPackages.request();
    }
  }
}
