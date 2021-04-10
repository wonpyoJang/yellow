import 'package:flutter/material.dart';
import 'package:yellow/src/image_providers/thumbnail_provider.dart';
import 'package:yellow/src/yellow_picker_adapter.dart';

import 'models/album.dart';
import 'models/medium.dart';

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
              body: ImagePanel(),
              bottomNavigationBar: Container(
                height: 44,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      child: Icon(
                        Icons.album,
                        size: 30.0,
                        color: Colors.white,
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

class ImagePanel extends StatefulWidget {
  @override
  _ImagePanelState createState() => _ImagePanelState();
}

class _ImagePanelState extends State<ImagePanel> {
  List<Album> _album;
  List<Medium> _media;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    _album = await YellowPickerAdapter.getAlbums();
    _media = await _album[0].getMedia();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true)
      return CircularProgressIndicator();
    else
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _media.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.black,
              width: 1,
            )),
            child: Image(
                width: 150,
                height: 250,
                fit: BoxFit.cover,
                image: ThumbnailProvider(
                    height: 10000,
                    width: 10000,
                    medium: _media[index],
                    highQuality: true)),
          );
        },
      );
  }
}
