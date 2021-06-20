import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:photo_gallery/photo_gallery.dart' as pg;
import 'package:yellow/src/models/medium.dart';

/// Fetches the given medium thumbnail from the gallery.
class ThumbnailProvider extends ImageProvider<ThumbnailProvider> {
  const ThumbnailProvider({
    @required this.medium,
    this.height,
    this.width,
    this.highQuality,
  }) : assert(medium != null);

  final Medium medium;
  final int height;
  final int width;
  final bool highQuality;

  @override
  ImageStreamCompleter load(key, decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () sync* {
        yield ErrorDescription('Id: ${medium.id}');
      },
    );
  }

  Future<ui.Codec> _loadAsync(
      ThumbnailProvider key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = await pg.PhotoGallery.getThumbnail(
      mediumId: medium.id,
      mediumType: medium.mediumType,
      height: height,
      width: width,
      highQuality: highQuality,
    );
    if (bytes.length == 0) return null;

    return await decode(Uint8List.fromList(bytes));
  }

  @override
  Future<ThumbnailProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ThumbnailProvider>(this);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final ThumbnailProvider typedOther = other;
    return medium.id == typedOther.medium.id;
  }

  @override
  int get hashCode => medium.id?.hashCode ?? 0;

  @override
  String toString() => '$runtimeType("${medium.id}")';
}
