import 'package:photo_gallery/photo_gallery.dart' as pg;
import 'models/album.dart';
import 'models/medium.dart';

class YellowPickerAdapter {
  static Future<List<Album>> getAlbums() async {
    List<pg.Album> albums =
        await pg.PhotoGallery.listAlbums(mediumType: pg.MediumType.image);
    return List.generate(albums.length, (index) => Album(albums[index]));
  }
}
