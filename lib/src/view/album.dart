import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_gallery/photo_gallery.dart' as pg;
import 'package:yellow/src/image_providers/thumbnail_provider.dart';
import 'package:yellow/src/view/viewer.dart';
import 'package:yellow/src/widget/select_button.dart';
import 'package:yellow/src/yellow_image_picker.dart';

import '../../yellow.dart';
import '../models/album.dart';
import '../models/medium.dart';
import '../selected_album_info.dart';

class AlbumView extends StatefulWidget {
  @override
  _AlbumViewState createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView>
    with SingleTickerProviderStateMixin {
  List<Album> _albums;
  List<Medium> _media;
  Album _selectedAlbum;
  bool _isLoading = true;
  GlobalKey gridKey = new GlobalKey();
  int multiSelectStartIndex = 0;
  int multiSelectCurrentIndex = 0;
  int multiSelectCurrentMaxIndex = 0;
  AnimationController expandController;
  Animation<double> animation;
  bool isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initAsync(context);
    prepareAnimations();
    _runExpandCheck();
  }

  void initAsync(BuildContext context) async {
    _selectedAlbum = YellowImagePicker.currentAlbumInfo.value.selectedAlbum;
    _albums = YellowImagePicker.currentAlbumInfo.value.albums;
    _media = YellowImagePicker.currentAlbumInfo.value.media;
    setState(() {
      _isLoading = false;
    });
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    expandController.reverse();
  }

  @override
  void didUpdateWidget(AlbumView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _media = await _albums[0].getMedia();
        YellowImagePicker.currentAlbumInfo.value.selectedAlbum = _albums[0];
        YellowImagePicker.currentAlbumInfo.value.media = _media;
        YellowImagePicker.currentAlbumInfo.value.albums = _albums;
        YellowImagePicker.exitYellowPicker(context);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: _albums.length > 1
                ? GestureDetector(
                    onTap: () {
                      if (isExpanded) {
                        expandController.reverse();
                        isExpanded = false;
                      } else {
                        expandController.forward();
                        isExpanded = true;
                      }
                    },
                    child: Text(_albums[0].album.name))
                : Text(""),
            actions: [
              GestureDetector(
                  onTap: () {
                    YellowImagePicker.isConfirmed = true;
                    YellowImagePicker.exitYellowPicker(context);
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 20),
                      width: 44,
                      height: 44,
                      child: Center(child: Text("Send"))))
            ],
          ),
          body: Stack(
            children: [
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                    ))
                  : ValueListenableBuilder(
                      valueListenable: YellowImagePicker.currentAlbumInfo,
                      builder: (BuildContext context, CurrentAlbumInfo data,
                          Widget child) {
                        if (data.media == null || data.media.length == 0) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Scrollbar(
                            isAlwaysShown: true,
                            controller: _scrollController,
                            child: GridView.builder(
                              controller: _scrollController,
                              key: gridKey,
                              scrollDirection: Axis.vertical,
                              itemCount: data.media.length,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 150,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0),
                              itemBuilder: (context, index) {
                                return buildImageItem(context, data, index);
                              },
                            ),
                          );
                        }
                      }),
              //drop down list for changing current album (default value : all media).
              SizeTransition(
                axisAlignment: 1.0,
                sizeFactor: animation,
                child: Container(
                    color: Colors.blue,
                    child: ListView.builder(
                      itemCount: _albums.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            _selectedAlbum = _albums[index];
                            _media = await _selectedAlbum.getMedia();
                            YellowImagePicker.currentAlbumInfo.value
                                .changeSelectedAlbum(_selectedAlbum, _media);
                            expandController.reverse();
                            setState(() {});
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: pg.AlbumThumbnailProvider(
                                          albumId: _albums[index].album.id,
                                          mediumType:
                                              _albums[index].album.mediumType,
                                          highQuality: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_albums[index].album.name),
                                      SizedBox(height: 5),
                                      Text(_albums[index]
                                          .album
                                          .count
                                          .toString()),
                                    ],
                                  )
                                ],
                              )),
                        );
                      },
                    )),
              ),
            ],
          )),
    );
  }

  Widget buildImageItem(
      BuildContext context, CurrentAlbumInfo data, int index) {
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
          onLongPressStart: (details) async {
            //need android permission : <uses-permission android:name="android.permission.VIBRATE" />
            await HapticFeedback.heavyImpact();

            double tapPositionX = details.globalPosition.dx;
            double tapPositionY = details.globalPosition.dy;
            int selectedItemIndex =
                getSelectedIndex(gridItemKey, tapPositionY, tapPositionX);
            multiSelectStartIndex = selectedItemIndex;
            if (YellowImagePicker.currentAlbumInfo.value
                    .media[selectedItemIndex].isSelected ==
                false) {
              YellowImagePicker.currentAlbumInfo.value
                  .addSelectedMediaByIndex(selectedItemIndex);
            }

            setState(() {});
          },
          onLongPressMoveUpdate: (details) {
            double tapPositionX = details.globalPosition.dx;
            double tapPositionY = details.globalPosition.dy;
            int selectedItemIndex =
                getSelectedIndex(gridItemKey, tapPositionY, tapPositionX);
            multiSelectCurrentIndex = selectedItemIndex;

            for (int i = multiSelectStartIndex; i <= selectedItemIndex; ++i) {
              YellowImagePicker.currentAlbumInfo.value
                  .addSelectedMediaByIndex(i);
            }

            for (int i = multiSelectCurrentMaxIndex;
                i > multiSelectCurrentIndex;
                --i) {
              YellowImagePicker.currentAlbumInfo.value
                  .removeSelectedMediaByIndex(i);
            }

            if (selectedItemIndex > multiSelectCurrentMaxIndex) {
              multiSelectCurrentMaxIndex = selectedItemIndex;
            }

            setState(() {});
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
              color: _media[index].isSelected ? Colors.yellow : Colors.black,
              width: 3,
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

  int getSelectedIndex(GlobalKey<State<StatefulWidget>> gridItemKey,
      double tapPositionY, double tapPositionX) {
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
    int indexY = ((tapPositionX - gridLeft) / _box.size.width).floor().toInt();
    int numberInRow = ((gridWidth) / _box.size.width).floor().toInt();
    int selectedItemIndex = indexX * numberInRow + indexY;
    return selectedItemIndex;
  }
}
