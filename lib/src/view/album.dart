import 'package:flutter/material.dart';
import 'package:yellow/src/image_providers/thumbnail_provider.dart';
import 'package:yellow/src/view/viewer.dart';
import 'package:yellow/src/yellow_picker_adapter.dart';

import '../models/album.dart';
import '../models/medium.dart';

class AlbumView extends StatefulWidget {
  @override
  _AlbumViewState createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
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
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
      ));
    else
      return Scaffold(
        appBar: AppBar(title: Text("album view")),
        body: GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _media.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 1,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewerPage(_media[index])),
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
                        medium: _media[index],
                        highQuality: true)),
              ),
            );
          },
        ),
      );
  }
}
