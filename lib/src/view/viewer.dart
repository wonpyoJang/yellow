import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart' as pg;
import 'package:yellow/src/image_providers/video_provider.dart';
import 'package:yellow/src/models/medium.dart';
import 'package:yellow/src/selected_album_info.dart';
import 'package:yellow/src/widget/select_button.dart';
import 'package:yellow/src/yellow_image_picker.dart';

class ViewerPage extends StatefulWidget {
  final int index;

  ViewerPage(this.index);

  @override
  _ViewerPageState createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  PageController controller;
  int currentPage;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
    currentPage = widget.index;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      preCacheLeftRight(widget.index, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
              "${currentPage + 1}/${YellowImagePicker.currentAlbumInfo.value.media.length}"),
        ),
        body: ValueListenableBuilder<CurrentAlbumInfo>(
            valueListenable: YellowImagePicker.currentAlbumInfo,
            builder: (context, value, child) {
              return PageView(
                controller: controller,
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                  preCacheLeftRight(page, context);
                },
                children: [
                  ...YellowImagePicker.currentAlbumInfo.value.media
                      .map(
                        (medium) => Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: medium.mediumType == pg.MediumType.image
                                  ? Image(
                                      fit: BoxFit.cover,
                                      image:
                                          pg.PhotoProvider(mediumId: medium.id),
                                    )
                                  : VideoProvider(
                                      mediumId: medium.id,
                                    ),
                            ),
                            SelectButton(medium: medium)
                          ],
                        ),
                      )
                      .toList(),
                ],
              );
            }),
      ),
    );
  }

  void preCacheLeftRight(int page, BuildContext context) {
    var media = YellowImagePicker.currentAlbumInfo.value.media;

    preCacheItem(page - 2, media, context);
    preCacheItem(page - 1, media, context);
    preCacheItem(page + 1, media, context);
    preCacheItem(page + 2, media, context);
  }

  void preCacheItem(int page, List<Medium> media, BuildContext context) {
    if ((page < media.length) && (page >= 0)) {
      var image = Image(
        fit: BoxFit.cover,
        image: pg.PhotoProvider(mediumId: media[page].id),
      );
      precacheImage(image.image, context);
    }
  }
}
