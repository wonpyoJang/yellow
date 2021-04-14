import 'package:flutter/material.dart';
import 'package:yellow/src/image_providers/thumbnail_provider.dart';
import 'package:yellow/src/view/viewer.dart';
import 'package:yellow/src/widget/select_button.dart';

import '../../yellow.dart';
import '../models/album.dart';
import '../models/medium.dart';
import '../selected_album_info.dart';

class AlbumView extends StatefulWidget {
  @override
  _AlbumViewState createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  List<Album> _albums;
  List<Medium> _media;
  Album _selectedAlbum;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initAsync(context);
  }

  void initAsync(BuildContext context) async {
    _selectedAlbum = YellowImagePicker.currentAlbumInfo.value.selectedAlbum;
    _albums = YellowImagePicker.currentAlbumInfo.value.albums;
    _media = YellowImagePicker.currentAlbumInfo.value.media;
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
      return Scaffold(
        appBar: AppBar(
          title: _albums.length > 1
              ? DropdownButton<String>(
                  value: _selectedAlbum.album.name,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) async {
                    _selectedAlbum = _albums
                        .where((item) => item.album.name == newValue)
                        .toList()[0];
                    _media = await _selectedAlbum.getMedia();
                    YellowImagePicker.currentAlbumInfo.value.selectedAlbum =
                        _selectedAlbum;
                    YellowImagePicker.currentAlbumInfo.value.media = _media;
                    setState(() {});
                  },
                  items: _albums.map<DropdownMenuItem<String>>((Album value) {
                    return DropdownMenuItem<String>(
                      value: value.album.name,
                      child: Text(value.album.name),
                    );
                  }).toList(),
                )
              : Text(_albums[0].album.name),
        ),
        body: ValueListenableBuilder(
            valueListenable: YellowImagePicker.currentAlbumInfo,
            builder:
                (BuildContext context, CurrentAlbumInfo data, Widget child) {
              return GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: data.media.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    childAspectRatio: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemBuilder: (context, index) {
                  return buidImageItem(context, data, index);
                },
              );
            }),
      );
  }

  Widget buidImageItem(BuildContext context, CurrentAlbumInfo data, int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewerPage(index)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.black,
              width: 1,
            )),
            child: Image(
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                image: ThumbnailProvider(
                    height: 10000,
                    width: 10000,
                    medium: data.media[index],
                    highQuality: true)),
          ),
        ),
        SelectButton(medium: _media[index],)
      ],
    );
  }
}
