import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow/src/models/medium.dart';

import '../../yellow.dart';

class SelectButton extends StatelessWidget {
  final Medium medium;

  SelectButton({this.medium});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            YellowImagePicker.currentAlbumInfo.value.toggleSelect(medium);
          },
          child: Container(
            width: 44,
            height: 44,
            child: medium.order > 0
                ? Center(child: Text(medium.order.toString()))
                : null,
            decoration: BoxDecoration(
              color: medium.isSelected ? Colors.yellow : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(22)),
            ),
          ),
        ),
      ),
    );
  }
}
