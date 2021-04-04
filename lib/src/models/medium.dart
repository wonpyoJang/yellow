import 'package:photo_gallery/photo_gallery.dart' as pg;

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
}

