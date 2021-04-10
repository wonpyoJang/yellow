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
    assert(result != null, 'No FrogColor found in context');
    return result;
  }

  @override
  bool updateShouldNotify(CurrentAlbum old) =>
      currentAlbumInfo != old.currentAlbumInfo;
}

class CurrentAlbumInfo {
  Album _album;
  List<Medium> _media;

  Album get album => _album;
  List<Medium> get media => _media;

  set album(Album album) =>  _album = album;
  set media(List<Medium> media) => _media = media;

  CurrentAlbumInfo();
}
