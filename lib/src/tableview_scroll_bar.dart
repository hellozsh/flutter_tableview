import 'package:flutter/material.dart';
import 'tableview_notifier.dart';


typedef void IndexChanged(int index);
typedef void GestureFinished();

abstract class TableViewScrollBar extends Widget {

  TableViewScrollBar({
    @required this.startAlignment,
    @required this.itemHeight,
    this.endAlignment,
  }) : assert(
  (startAlignment != null),
  'startAlignment不能为null',
  ), assert(
  (itemHeight != null),
  'itemHeight不能为null',
  );

  final Alignment startAlignment; // 起始位置
  final Alignment endAlignment;  // 结束位置-,未设置则不滚动
  final double itemHeight;
}

class TableViewHeaderScrollBar extends StatefulWidget  implements TableViewScrollBar {

  TableViewHeaderScrollBar({
    this.startAlignment,
    this.itemHeight,
    this.endAlignment,
    @required this.headerTitleList,
    this.choseSection,
    this.indexChanged,
    this.gestureFinished,
  }): assert(
  (startAlignment != null),
  'startAlignment不能为null',
  ), assert(
  (itemHeight != null),
  'itemHeight不能为null',
  );

  final List<String> headerTitleList;
  final Alignment startAlignment; // 起始位置
  final Alignment endAlignment;  // 结束位置-,未设置则不滚动
  final int choseSection;
  final double itemHeight;
  final IndexChanged indexChanged;
  final GestureFinished gestureFinished;

  @override
  TableViewHeaderScrollBarState createState() {
    // TODO: implement createState
    return TableViewHeaderScrollBarState();
  }

}

class TableViewHeaderScrollBarState extends State<TableViewHeaderScrollBar> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GestureDetector(

      behavior: HitTestBehavior.translucent,
      onPanStart: (event) {
        int index = choseIndexWithPosition(context,event.localPosition);
        TableViewBarNotifier(index).dispatch(context);
        if(widget.indexChanged != null) {
          widget.indexChanged(index);
        }
      },
      onPanDown: (event) {

        int index = choseIndexWithPosition(context,event.localPosition);
        TableViewBarNotifier(index).dispatch(context);
        if(widget.indexChanged != null) {
          widget.indexChanged(index);
        }
      },
      onVerticalDragUpdate: (event) {

        int index = choseIndexWithPosition(context,event.localPosition);
        TableViewBarNotifier(index).dispatch(context);
        if(widget.indexChanged != null) {
          widget.indexChanged(index);
        }
      },
      onPanCancel: () {
        if(widget.gestureFinished != null) {
          widget.gestureFinished();
        }
      },
      onVerticalDragEnd: (event) {
        if(widget.gestureFinished != null) {
          widget.gestureFinished();
        }
      },

      child: Container(
        width: 20,

        child: Wrap(
          direction: Axis.vertical,
          children: widget.headerTitleList.asMap().keys.map((index) {

            return Container(
              height: widget.itemHeight,
              child: Text(
                widget.headerTitleList[index],
                style: TextStyle(
                  fontSize: 12,
                  color: index == widget.choseSection ? Colors.blue : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  int choseIndexWithPosition(BuildContext context, Offset localOffset) {

    int index = (localOffset.dy / widget.itemHeight).ceil();
    index = index - 1;

    if(index < 0) {
      index = 0;
    } else if(index > widget.headerTitleList.length-1) {
      index = widget.headerTitleList.length-1;
    }

    return index;
  }

}

