import 'package:flutter/material.dart';
import 'package:yellow/src/image_providers/thumbnail_provider.dart';
import 'package:yellow/src/yellow_picker_adapter.dart';

import 'models/album.dart';
import 'models/medium.dart';

class YellowImagePicker {

  static void pickImages(BuildContext context, {
    @required String title,
    double height = 400
  }) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: Container(
              height: height,
              child: ImagePanel()
            ),
          );
        }
    );
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
    if(_isLoading == true)
      return Container();
    else
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _media.length,
      itemBuilder: (context, index) {
        return Container(
          width: 100,
          height: 100,
          child: Image(
            image: ThumbnailProvider(medium: _media[index])
          ),
        );
      },
    );
  }
}
