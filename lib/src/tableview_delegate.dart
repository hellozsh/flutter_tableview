

import 'package:flutter/cupertino.dart';

import 'tableview_notifier.dart';

class IndexPath {

  int section;  // 组
  int row;// 行

  IndexPath({this.section, this.row});

  IndexPath.zero(){
    section = 0;
    row = 0;
  }
}

/// 默认返回1
typedef int NumberOfSectionsInTableView();
typedef int NumberOfRowsInSection(int section);

typedef double HeightForRowAtIndexPath(IndexPath indexPath);
typedef double HeightForHeaderInSection(int section);

typedef Widget CellForRowAtIndexPath(BuildContext context, IndexPath indexPath);
typedef Widget ViewForHeaderInSection(BuildContext context, int section);

class TableViewDelegate {

  TableViewDelegate({

    this.numberOfSectionsInTableView,
    this.numberOfRowsInSection,

    this.heightForRowAtIndexPath,
    this.heightForHeaderInSection,

    this.viewForHeaderInSection,
    this.cellForRowAtIndexPath,
});

  final NumberOfSectionsInTableView numberOfSectionsInTableView;
  final NumberOfRowsInSection numberOfRowsInSection;

  final HeightForRowAtIndexPath heightForRowAtIndexPath;
  final HeightForHeaderInSection heightForHeaderInSection;

  final CellForRowAtIndexPath cellForRowAtIndexPath;
  final ViewForHeaderInSection viewForHeaderInSection;
}