import 'package:battery_manager/provider/myProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MusicChange extends StatefulWidget {
  const MusicChange({Key? key}) : super(key: key);

  @override
  _MusicChangeState createState() => _MusicChangeState();
}

class _MusicChangeState extends State<MusicChange> {
  static const platform = const MethodChannel('battery');

  @override
  Widget build(BuildContext context) {
    if (Provider.of<MyProvider>(context, listen: false).music != "Default") {
      String fileNameWithExt =
          Provider.of<MyProvider>(context, listen: false).music.split('/').last;
      Provider.of<MyProvider>(context, listen: false).music =
          fileNameWithExt.split('.').first;
    }
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
          pickAndSet();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.music_note_outlined,
              size: 50,
              color: Colors.red,
            ),
            Text(
              "Music",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(Provider.of<MyProvider>(context, listen: false)
                      .fontColor)),
            ),
            Text(
              Provider.of<MyProvider>(context, listen: false).music,
              maxLines: 1,
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

  void pickAndSet() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      String path = result.files.single.path.toString();
      if (path.split('.').last == "mp3") {
        setState(() {
          Provider.of<MyProvider>(context, listen: false).music = path;
        });
        await platform.invokeMethod("setMusic", {"path": path});
      }
    } else {
      // User canceled the picker
    }
  }
}
