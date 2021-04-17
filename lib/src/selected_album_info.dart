import 'dart:collection';
import 'dart:io';

import 'package:yellow/src/yellow_image_picker.dart';
import 'package:photo_gallery/photo_gallery.dart' as pg;

import 'models/album.dart';
import 'models/medium.dart';

class CurrentAlbumInfo {
  List<Album> _albums;
  Album _selectedAlbum;
  List<Medium> _media;
  Queue<Medium> _selectedMedia = Queue();

  // ignore: unnecessary_getters_setters
  List<Album> get albums => _albums;
  // ignore: unnecessary_getters_setters
  Album get selectedAlbum => _selectedAlbum;
  // ignore: unnecessary_getters_setters
  List<Medium> get media => _media;

  // ignore: unnecessary_getters_setters
  set selectedAlbum(Album album) =>  _selectedAlbum = album;
  // ignore: unnecessary_getters_setters
  set media(List<Medium> media) => _media = media;
  // ignore: unnecessary_getters_setters
  set albums(List<Album> albums) => _albums = albums;

  CurrentAlbumInfo();

  void addSelectedMedia(Medium medium) {
    _selectedMedia.addLast(medium);
    medium.isSelected = true;

    calculateOrder();

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    YellowImagePicker.currentAlbumInfo.notifyListeners();
  }

  void addSelectedMediaByIndex(int index) {
    if(media[index].isSelected) return;

    _selectedMedia.addLast(_media[index]);
    _media[index].isSelected = true;

    calculateOrder();

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    YellowImagePicker.currentAlbumInfo.notifyListeners();
  }

  void removeSelectedMedia(Medium medium) {
    _selectedMedia.remove(medium);
    medium.isSelected = false;
    medium.order = 0;

    calculateOrder();

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    YellowImagePicker.currentAlbumInfo.notifyListeners();
  }

  void removeSelectedMediaByIndex(int index) {
    _selectedMedia.remove(_media[index]);
    _media[index].isSelected = false;
    _media[index].order = 0;

    calculateOrder();

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    YellowImagePicker.currentAlbumInfo.notifyListeners();
  }

  void toggleSelect(Medium medium) {
    if(medium.isSelected) {
      removeSelectedMedia(medium);
    } else {
      addSelectedMedia(medium);
    }
  }

  void calculateOrder() {
    int cnt = 1;
    for(var item in _selectedMedia) {
      item.order = cnt;
      ++cnt;
    }
  }

  Future<List<File>> getSelectedFiles() async {
    List<File> files = [];

    for(Medium item in _selectedMedia) {
      File file = await pg.PhotoGallery.getFile(mediumId: item.id);
      files.add(file);
    }
    return files;
  }

  void changeSelectedAlbum(Album newAlbum, List<Medium> newMedia) {
    _selectedAlbum =
        newAlbum;
    _media = newMedia;
    _selectedMedia.clear();
  }

}
