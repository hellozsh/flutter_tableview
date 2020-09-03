
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


abstract class TableViewCenterTip extends Widget {

  TableViewCenterTip({
    this.alignment = Alignment.center,
  });
  final Alignment alignment; // 放置的位置，默认中心

}


class TableViewCenterTitle extends StatefulWidget implements TableViewCenterTip  {

  TableViewCenterTitle({
    this.title = "",
    this.alignment = Alignment.center,
    this.backgroundColor = Colors.black26,
    this.size = const Size(50, 50),
    this.borderRadius = 6,
    this.textStyle = const TextStyle(fontSize: 20, color:  Colors.white),
  });

  final String title; // 文字
  final Alignment alignment; // 放置的位置，默认中心
  final Size size;
  final Color backgroundColor;
  final double borderRadius;
  final TextStyle textStyle;

  @override
  TableViewCenterTitleState createState() {
    return TableViewCenterTitleState();
  }
}

class TableViewCenterTitleState extends State<TableViewCenterTitle> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return widget.title.length > 0 ? Container(
      width: widget.size.width,
      height: widget.size.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),

      child: Center(
        child: Text(
          widget.title,
          style: widget.textStyle,
        ),
      ),
    ) : Container();
  }

}

