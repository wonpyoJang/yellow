import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';

import 'selected_album_info.dart';
import 'view/album.dart';
import 'widget/image_panel.dart';

class YellowImagePicker {
  static ValueNotifier<CurrentAlbumInfo> currentAlbumInfo =
      ValueNotifier<CurrentAlbumInfo>(CurrentAlbumInfo());

  static String yellowPickerRoot = "/yellow";

  static void exitYellowPicker(BuildContext context) {
    Navigator.of(context)
        .popUntil(ModalRoute.withName(YellowImagePicker.yellowPickerRoot));
    Navigator.of(context).pop();
  }

  static Future<List<File>> pickImages(BuildContext context,
      {@required String title, double height = 294}) async {
    // initialize current state
    currentAlbumInfo = ValueNotifier<CurrentAlbumInfo>(CurrentAlbumInfo());

    // check if user confirmed uploading images;
    bool isConfirmed = false;

    await showModalBottomSheet(
        context: context,
        routeSettings: RouteSettings(name: yellowPickerRoot),
        builder: (BuildContext context) {
          return Container(
            height: height,
            child: Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.black54,
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          exitYellowPicker(context);
                        },
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13.0)),
                            ),
                            child: Icon(Icons.arrow_upward_outlined,
                                color: Colors.black)),
                      )
                    ],
                  )),
              body: ImagePanel(),
              bottomNavigationBar: Container(
                height: 44,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (context) => AlbumView()),
                        );
                      },
                      child: Container(
                        height: 44,
                        width: 44,
                        child: Icon(
                          Icons.album,
                          size: 30.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: 44,
                      width: 44,
                      child: Icon(
                        Icons.edit,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
    return isConfirmed
        ? YellowImagePicker.currentAlbumInfo.value.getSelectedFiles()
        : [];
  }
}
