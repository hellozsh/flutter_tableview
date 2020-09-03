


import 'package:flutter/material.dart';


///用户账户信息
class TableViewNotifier extends Notification {

  int scrollSection;

  TableViewNotifier(this.scrollSection);
}


///用户账户信息
class TableViewBarNotifier extends Notification {

  int choseSection;

  TableViewBarNotifier(this.choseSection);
}
