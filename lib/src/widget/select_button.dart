import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow/src/models/medium.dart';

import '../../yellow.dart';

class SelectButton extends StatelessWidget {
  final Medium medium;

  SelectButton({Key key, this.medium});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            YellowImagePicker.currentAlbumInfo.value.toggleSelect(this.medium);
          },
          child: Container(
            width: 85,
            height: 85,
            padding: EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 30,
                height: 30,
                child: this.medium.order > 0
                    ? Center(child: Text(medium.order.toString()))
                    : null,
                decoration: BoxDecoration(
                    color: this.medium.isSelected
                        ? Colors.yellow
                        : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 3)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
