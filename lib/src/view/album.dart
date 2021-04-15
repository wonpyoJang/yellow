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
  GlobalKey gridKey = new GlobalKey();
  int multiSelectStartIndex = 0;
  int multiSelectCurrentIndex = 0;
  int multiSelectCurrentMaxIndex = 0;

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
                    YellowImagePicker.currentAlbumInfo.value =
                        CurrentAlbumInfo();
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
                key: gridKey,
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
    GlobalKey gridItemKey = new GlobalKey();

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewerPage(index)),
            );
          },
          onLongPressStart: (details) {
            double tapPositionX = details.globalPosition.dx;
            double tapPositionY = details.globalPosition.dy;
            int selectedItemIndex = getSelectedIndex(gridItemKey, tapPositionY, tapPositionX);
            multiSelectStartIndex = selectedItemIndex;
            if (YellowImagePicker.currentAlbumInfo.value
                    .media[selectedItemIndex].isSelected ==
                false) {
              YellowImagePicker.currentAlbumInfo.value.addSelectedMediaByIndex(selectedItemIndex);
            }
            setState(() {});
          },
          onLongPressMoveUpdate: (details) {
            double tapPositionX = details.globalPosition.dx;
            double tapPositionY = details.globalPosition.dy;
            int selectedItemIndex = getSelectedIndex(gridItemKey, tapPositionY, tapPositionX);
            multiSelectCurrentIndex = selectedItemIndex;

            for(int i = multiSelectStartIndex; i <= selectedItemIndex; ++i) {
              YellowImagePicker.currentAlbumInfo.value.addSelectedMediaByIndex(i);
            }

            for(int i = multiSelectCurrentMaxIndex; i > multiSelectCurrentIndex; --i) {
              YellowImagePicker.currentAlbumInfo.value.removeSelectedMediaByIndex(i);
            }

            if(selectedItemIndex > multiSelectCurrentMaxIndex) {
              multiSelectCurrentMaxIndex = selectedItemIndex;
            }

            setState(() {
            });
          },
          onLongPressEnd: (details) {
            multiSelectCurrentIndex = 0;
            multiSelectCurrentMaxIndex = 0;
            multiSelectStartIndex = 0;
          },
          child: Container(
            key: gridItemKey,
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
        SelectButton(
          medium: _media[index],
        )
      ],
    );
  }

  int getSelectedIndex(GlobalKey<State<StatefulWidget>> gridItemKey, double tapPositionY, double tapPositionX) {
    RenderBox _box = gridItemKey.currentContext.findRenderObject();
    RenderBox _boxGrid = gridKey.currentContext.findRenderObject();
    Offset position =
        _boxGrid.localToGlobal(Offset.zero); //this is global position
    double gridLeft = position.dx;
    double gridTop = position.dy;
    double gridWidth = _boxGrid.size.width;
    
    double gridPosition = tapPositionY - gridTop;
    
    //Get item position
    int indexX = (gridPosition / _box.size.width).floor().toInt();
    int indexY =
        ((tapPositionX - gridLeft) / _box.size.width)
            .floor()
            .toInt();
    int numberInRow =
        ((gridWidth) / _box.size.width).floor().toInt();
    int selectedItemIndex = indexX * numberInRow + indexY;
    return selectedItemIndex;
  }
}
