import 'package:photo_gallery/photo_gallery.dart' as pg;
import 'medium.dart';

class Album {
  pg.Album album;

  Album(this.album);

  Future<List<Medium>> getMedia() async {
    List<pg.Medium> media;
    pg.MediaPage mediaPage;
    try {
      mediaPage = await album.listMedia();
    } catch (_) {
      print(_);
    }
    media = mediaPage.items;
    return List.generate(media.length, (index) => Medium(media[index]));
  }
}
