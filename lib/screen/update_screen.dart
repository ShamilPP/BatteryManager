import 'dart:io';

import 'package:battery_manager/public/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const platform = const MethodChannel('battery');

  @override
  void initState() {
    createFolder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  onClick: () async {
                    checkInstallPermission();
                    if (updateAvailable) {
                      downloadUpdate(updateLink);
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

  downloadUpdate(String url) async {
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
      String folderPath =
          await platform.invokeMethod('getDownloadPath') + '/Battery Manager';
      final file = File(folderPath + '/Battery Manager.apk');
      installUpdate(file.path, folderPath);
    });
  }

  installUpdate(String path, String folderPath) async {
    dialog(
        context,
        "Install Update",
        Container(
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                ElevatedButton(
                  onPressed: () {
                    OpenFile.open(path);
                  },
                  child: Text("Install"),
                ),
                MaterialButton(
                  onPressed: () {
                    dialog(
                        context,
                        "Advanced Install",
                        SingleChildScrollView(
                            child: ListBody(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                platform.invokeMethod("openDownloadFolder");
                              },
                              child: Text("Open File manager"),
                            ),
                            ListTile(
                              title: Text("App not installed ?"),
                              onTap: () {
                                dialog(
                                    context,
                                    "HOW TO SOLVE APP NOT INSTALLED",
                                    Text(
                                        '1. Uninstall "Battery manager"\n2. Open Download folder \n3. Install "Battery manager"'),
                                    "Cancel", () {
                                  Navigator.pop(context);
                                });
                              },
                            )
                          ],
                        )),
                        "Cancel", () {
                      Navigator.pop(context);
                    });
                  },
                  child: Text("Advanced"),
                )
              ],
            ),
          ),
        ),
        "Cancel", () {
      Navigator.pop(context);
    });
  }

  void createFolder() async {
    String folderPath =
        await platform.invokeMethod('getDownloadPath') + '/Battery Manager';
    Directory mkDir = Directory(folderPath);
    File rmFile = File(folderPath);
    if (await rmFile.exists()) {
      await rmFile.delete();
    }
    if (!await mkDir.exists()) {
      await mkDir.create();
    }
  }

  void checkInstallPermission() async {
    if (await Permission.requestInstallPackages.isDenied) {
      Permission.requestInstallPackages.request();
    }
    if (await Permission.manageExternalStorage.isDenied) {
      Permission.manageExternalStorage.request();
    }
  }
}
