import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yellow/yellow.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'yellow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Yellow'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> imageFiles = [];

  @override
  Widget build(BuildContext context) {
    Future<bool> _promptPermissionSetting() async {
      if (Platform.isIOS &&
              await Permission.storage.request().isGranted &&
              await Permission.photos.request().isGranted ||
          Platform.isAndroid && await Permission.storage.request().isGranted) {
        return true;
      }
      return false;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: imageFiles.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 1,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0),
              itemBuilder: (context, index) {
                return Image.file(imageFiles[index]);
              },
            ),
            MaterialButton(
                onPressed: () async {
                  if (await _promptPermissionSetting()) {
                    var result = await YellowImagePicker.pickImages(context,
                        title: "yellow picker");

                    if(result.isNotEmpty) {
                      imageFiles = result;
                      setState(() {});
                    }
                  }
                },
                color: Colors.grey[200],
                child: Text("Add Photo")),
          ],
        ));
  }
}
