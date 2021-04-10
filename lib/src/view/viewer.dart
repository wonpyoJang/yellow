import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart' as pg;
import 'package:transparent_image/transparent_image.dart';
import 'package:yellow/src/image_providers/video_provider.dart';

import '../models/medium.dart';

class ViewerPage extends StatelessWidget {
  final Medium medium;

  ViewerPage(Medium medium) : medium = medium;

  @override
  Widget build(BuildContext context) {
    DateTime date = medium.creationDate ?? medium.modifiedDate;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(date?.toLocal().toString()),
        ),
        body: Container(
          alignment: Alignment.center,
          child: medium.mediumType == pg.MediumType.image
              ? Image(
                  fit: BoxFit.cover,
                  image: pg.PhotoProvider(mediumId: medium.id),
                )
              : VideoProvider(
                  mediumId: medium.id,
                ),
        ),
      ),
    );
  }
}
