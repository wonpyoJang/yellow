import 'package:flutter/material.dart';
import 'package:yellow/src/image_providers/thumbnail_provider.dart';
import 'package:yellow/src/view/viewer.dart';
import 'package:yellow/src/widget/select_button.dart';
import 'package:yellow/src/yellow_picker_adapter.dart';

import '../../yellow.dart';
import '../models/album.dart';
import '../models/medium.dart';
import '../selected_album_info.dart';

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
    YellowImagePicker.currentAlbumInfo.value.selectedAlbum = _album[0];
    YellowImagePicker.currentAlbumInfo.value.media = _media;
    YellowImagePicker.currentAlbumInfo.value.albums = _album;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true)
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
      ));
    else
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _media.length,
        itemBuilder: (context, index) {
          return buildMediaItem(context, index);
        },
      );
  }

  Widget buildMediaItem(BuildContext context, int index) {
    return ValueListenableBuilder<CurrentAlbumInfo>(
        valueListenable: YellowImagePicker.currentAlbumInfo,
        builder: (context, value, child) {
          return Stack(
            children: [buildImage(context, index), buildSelectButton(index)],
          );
        });
  }

  Widget buildImage(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewerPage(index)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: _media[index].isSelected ? Colors.yellow : Colors.black,
            width: 5,
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
        ));
  }

  Widget buildSelectButton(int index) {
    return SelectButton(medium: _media[index]);
  }
}
