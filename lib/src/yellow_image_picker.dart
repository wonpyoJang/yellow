import 'package:flutter/material.dart';

import 'selected_album_info.dart';
import 'view/album.dart';
import 'widget/image_panel.dart';

class YellowImagePicker {
  static void pickImages(BuildContext context,
      {@required String title, double height = 294}) async {
    showModalBottomSheet(
        context: context,
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
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius:
                                BorderRadius.all(Radius.circular(13.0)),
                          ),
                          child: Icon(Icons.arrow_upward_outlined,
                              color: Colors.black))
                    ],
                  )),
              body: CurrentAlbum(currentAlbumInfo: CurrentAlbumInfo(), child: ImagePanel()),
              bottomNavigationBar: Container(
                height: 44,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
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
  }
}