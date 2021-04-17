import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow/src/models/medium.dart';

import '../../yellow.dart';

class SelectButton extends StatefulWidget {
  final Medium medium;

  SelectButton({Key key, this.medium});

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {

  bool isDark = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();

  }

  initAsync() async {
    this.isDark = await widget.medium.isImageDark();
    print("isBlack : " + this.isDark.toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            YellowImagePicker.currentAlbumInfo.value.toggleSelect(widget.medium);
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
                child: this.widget.medium.order > 0
                    ? Center(child: Text(widget.medium.order.toString()))
                    : null,
                decoration: BoxDecoration(
                    color: this.widget.medium.isSelected
                        ? Colors.yellow
                        : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                        color: this.isDark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5),
                        width: 3)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
