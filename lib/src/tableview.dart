
import 'package:flutter/material.dart';
import 'tableview_center_tip.dart';
import 'tableview_notifier.dart';
import 'tableview_scroll_bar.dart';
import 'tableview_delegate.dart';

typedef Widget ListViewFatherWidgetBuilder(BuildContext context, Widget canScrollWidget);

class TableView extends StatefulWidget {

  TableView({
    this.listViewFatherWidgetBuilder,
    @required this.delegate,
    this.scrollbar,
    this.headerHover = true,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.backgroundColor,
    this.centerTip,
  })  : assert(
  (delegate != null),
  'delegate 不能为 null',
  );

  @override
  _TableViewState createState() {
    return _TableViewState();
  }

  final ListViewFatherWidgetBuilder listViewFatherWidgetBuilder;

  final TableViewDelegate delegate;

  final TableViewScrollBar scrollbar;
  final TableViewCenterTip centerTip;

  final bool headerHover; // header是否悬停
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final double cacheExtent;
  final Color backgroundColor;

}

class _TableViewState extends State<TableView>  with AutomaticKeepAliveClientMixin {

  bool get wantKeepAlive => true;

  ScrollController scrollController;
  List headerDataSourceList = List();
  int totalCount;
  SectionHeaderModel currentHeaderModel;
  double preHeight = 0;

  double maxScrollExtent;
  Alignment scrollAlignment;

  @override
  void initState() {
    super.initState();

    scrollAlignment = widget?.scrollbar?.startAlignment ?? Alignment.centerRight;
    this._initBaseData();
    this._initScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  void _initScrollController(){

    scrollController = ScrollController(initialScrollOffset: 0);
  }

  void _updateCurrentSectionHeaderModel(
      SectionHeaderModel model, double topOffset) {

    if(model != this.currentHeaderModel) {

      this.currentHeaderModel = model;
      if(this.currentHeaderModel != null) {
        this.currentHeaderModel.topOffset = topOffset;
        TableViewNotifier(this.currentHeaderModel.section).dispatch(context);
      } else {
        setState(() {

        });
      }
    } else {

      if(this.currentHeaderModel != null && this.currentHeaderModel.topOffset != topOffset) {
        this.currentHeaderModel.topOffset = topOffset;
        setState(() {

        });
      }
    }
  }

  void _initBaseData(){

    int sectionCount = 1;
    if(widget?.delegate?.numberOfSectionsInTableView != null) {
      sectionCount = widget.delegate.numberOfSectionsInTableView();
    }

    double offsetY = 0;
    totalCount = 0;
    for(int section = 0; section < sectionCount; section ++) {

      double sectionHeight = 0;
      if(widget?.delegate?.viewForHeaderInSection != null) {

        if(widget?.delegate?.heightForHeaderInSection != null) {
          sectionHeight = widget?.delegate?.heightForHeaderInSection(section);
        }
      }

      SectionHeaderModel sectionHeaderModel = SectionHeaderModel(
        minY: offsetY,
        section: section,
        index: totalCount,
      );
      totalCount += 1;
      headerDataSourceList.add(sectionHeaderModel);

      offsetY += sectionHeight;

      int rowCount = 0;
      if(widget?.delegate?.numberOfRowsInSection(section) != null) {
        rowCount = widget?.delegate?.numberOfRowsInSection(section);
      }
      for(int row = 0; row < rowCount; row++) {

        IndexPath indexPath = IndexPath(section: section, row: row);
        if(widget?.delegate?.cellForRowAtIndexPath(context, indexPath) != null) {
          double cellHeight = 0;
          if(widget?.delegate?.heightForRowAtIndexPath(indexPath) != null) {
            cellHeight = widget?.delegate?.heightForRowAtIndexPath(indexPath);
          }
          offsetY += cellHeight;
        }
      }
      totalCount += rowCount;
    }
  }

  void updateStackHeader(double maxScrollHeight, double currentHeight) {

    maxScrollExtent = maxScrollHeight;
    double progress = currentHeight / maxScrollHeight;

    if(widget?.scrollbar?.endAlignment != null && widget?.scrollbar?.startAlignment != null) {

      double x = widget.scrollbar.startAlignment.x + progress * (widget.scrollbar.endAlignment.x - widget.scrollbar.startAlignment.x);
      double y = widget.scrollbar.startAlignment.y + progress * (widget.scrollbar.endAlignment.y - widget.scrollbar.startAlignment.y);
      scrollAlignment = Alignment(x, y);
    }

    double offsetY = currentHeight;
    if(offsetY <= 0) {
      _updateCurrentSectionHeaderModel(null, 0);
    } else {

      SectionHeaderModel nextModel = headerDataSourceList.last;
      SectionHeaderModel preModel = headerDataSourceList.first;

      int currentIndex = 1;
      int maxIndex = headerDataSourceList.length;
      if(currentHeight - preHeight > 0) {
        currentIndex = currentHeaderModel?.index ?? 0;
      } else {
        maxIndex = currentHeaderModel?.index ?? maxIndex;
      }
      for(int i = 1; i < headerDataSourceList.length; i++) {

        SectionHeaderModel model = this.headerDataSourceList[i];
        if(offsetY >= preModel.minY && offsetY < model.minY) {

          nextModel = model;
          break;
        }
        preModel = model;
      }

      if(nextModel == null) {
        _updateCurrentSectionHeaderModel(nextModel, 0);
      } else {

        double delta = nextModel.minY - currentHeight;

        double height = widget?.delegate?.heightForHeaderInSection(preModel.section);
        double topOffset;
        if (delta >= height) {
          topOffset = 0.0;

        } else {
          topOffset = delta - height;
        }
        _updateCurrentSectionHeaderModel(preModel, topOffset);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget listView = _listView();
    Widget listViewFatherWidget;
    if (widget.listViewFatherWidgetBuilder != null) {
      listViewFatherWidget =
          this.widget.listViewFatherWidgetBuilder(context, listView);
    }

    Widget listViewWidget = listViewFatherWidget ?? listView;

    Widget currHeader;
    double headerHeight = 0;
    if(currentHeaderModel != null) {
      currHeader = widget?.delegate?.viewForHeaderInSection(context,currentHeaderModel.section);
      headerHeight = widget?.delegate?.heightForHeaderInSection(currentHeaderModel.section);
    }

    return NotificationListener<TableViewBarNotifier> (
      onNotification: (notification) {

        if(notification.choseSection < headerDataSourceList.length) {
          SectionHeaderModel model = headerDataSourceList[notification.choseSection];
          if(maxScrollExtent == null) {
            scrollController.jumpTo(model.minY);
          } else if(model.minY > maxScrollExtent) {
            scrollController.jumpTo(maxScrollExtent);
          } else {
            scrollController.jumpTo(model.minY);
          }
        }
        return true;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification) {

            updateStackHeader(notification.metrics.maxScrollExtent, notification.metrics.pixels);

            return true;
          } else if(notification is ScrollUpdateNotification) {

            updateStackHeader(notification.metrics.maxScrollExtent, notification.metrics.pixels);
            preHeight = notification.metrics.pixels;
//            _updateCurrentSectionHeaderModel(null, 0);

            return true;
          } else {
            return false;
          }
        },
        child:  Container(
          padding: this.widget.padding,
          color: widget.backgroundColor,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.transparent,
                child: listViewWidget,
              ),

              (this.currentHeaderModel != null &&
                  currHeader != null && widget.headerHover == true) ?
              Positioned(
                top: this.currentHeaderModel.topOffset,
                left: 0.0,
                right: 0.0,
                height: headerHeight,
                child: Container(
                  color: Colors.white,
                  child: currHeader,
                ),
              ) : Container(),
              Offstage(
                offstage: widget.scrollbar == null,
                child: Align(
                  alignment: scrollAlignment,
                  child: widget?.scrollbar,
                ),
              ),
              Offstage(
                offstage: widget.centerTip == null,
                child: Align(
                  alignment: widget?.centerTip?.alignment ?? Alignment.center,
                  child: widget?.centerTip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IndexPath getIndexPathWithIndex(int index) {
    SectionHeaderModel choseHeaderModel = headerDataSourceList.last;

    for(int i = 0; i < headerDataSourceList.length; i++) {
      SectionHeaderModel sectionHeaderModel = headerDataSourceList[i];
      if(sectionHeaderModel.index > index) {
        choseHeaderModel = headerDataSourceList[i-1];
        break;
      } else if(sectionHeaderModel.index == index) {
        choseHeaderModel = sectionHeaderModel;
        break;
      }
    }

    return IndexPath(section: choseHeaderModel.section, row: index-choseHeaderModel.index-1);
  }

  Widget _listView() {

    return ListView.builder(

      controller: scrollController,
      physics: widget.physics ?? AlwaysScrollableScrollPhysics(),
      shrinkWrap: widget.shrinkWrap,
      cacheExtent: widget.cacheExtent,
      itemBuilder: (BuildContext context, int index) {

        print("=============================");
        IndexPath indexPath = getIndexPathWithIndex(index);
        Widget itemWidget;
        double height = 0;
        if(indexPath.row == -1) {
          height = widget?.delegate?.heightForHeaderInSection(indexPath.section);
          itemWidget = widget?.delegate?.viewForHeaderInSection(context,indexPath.section);
        } else {
          height = widget?.delegate?.heightForRowAtIndexPath(indexPath);
          itemWidget = widget?.delegate?.cellForRowAtIndexPath(context,indexPath);
        }
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height,
            maxHeight: height,
          ),
          child: itemWidget,
        );
      },
      itemCount: totalCount,
    );
  }

}

class SectionHeaderModel {

  SectionHeaderModel({
    this.minY,
    this.section,
    this.index,
    this.height,
  });

  double topOffset;

  final double minY;
  final double height;
  final int section;
  final int index;

}

//endregion