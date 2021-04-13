import 'package:flutter/material.dart';

import 'models/album.dart';
import 'models/medium.dart';

class CurrentAlbum extends InheritedWidget {
  const CurrentAlbum({
    Key key,
    @required this.currentAlbumInfo,
    @required Widget child,
  }) : super(key: key, child: child);

  final CurrentAlbumInfo currentAlbumInfo;

  static CurrentAlbum of(BuildContext context) {
    final CurrentAlbum result =
        context.dependOnInheritedWidgetOfExactType<CurrentAlbum>();
    assert(result != null, 'No CurrentAlbum found in context');
    return result;
  }

  @override
  bool updateShouldNotify(CurrentAlbum old) =>
      currentAlbumInfo != old.currentAlbumInfo;
}

class CurrentAlbumInfo {
  List<Album> _albums;
  Album _selectedAlbum;
  List<Medium> _media;

  List<Album> get albums => _albums;
  Album get selectedAlbum => _selectedAlbum;
  List<Medium> get media => _media;

  set selectedAlbum(Album album) =>  _selectedAlbum = album;
  set media(List<Medium> media) => _media = media;
  set albums(List<Album> albums) => _albums = albums;

  CurrentAlbumInfo();
}
