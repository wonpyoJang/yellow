import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:photo_gallery/photo_gallery.dart' as pg;
import 'dart:ui' as ui;

class Medium {
  pg.Medium _medium;

  Medium(this._medium);

  get id => _medium.id;

  get mediumType => _medium.mediumType;

  /// The medium width.
  get width => _medium.width;

  /// The medium height.
  get height => _medium.height;

  /// The medium mimeType.
  get mimeType => _medium.mimeType;

  /// The duration of video
  get duration => _medium.duration;

  /// The date at which the photo or video was taken.
  get creationDate => _medium.creationDate;

  /// The date at which the photo or video was modified.
  get modifiedDate => _medium.modifiedDate;

  bool isSelected = false;
  int order = 0;
  pg.ThumbnailProvider thumbnailProvider;

  pg.ThumbnailProvider getThumbnail() {
    if (thumbnailProvider == null) {
      thumbnailProvider = pg.ThumbnailProvider(
          height: 10000, width: 10000, mediumId: id, highQuality: true);
    }
    return thumbnailProvider;
  }

  Future<ui.Image> getThumbnailImage() async {
    Completer<ImageInfo> completer = Completer();
    var img = pg.ThumbnailProvider(
        height: 10000, width: 10000, mediumId: id, highQuality: true);
    img
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }
}
