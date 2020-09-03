

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chose_nation.dart';
import 'chose_nation_2.dart';
import 'chose_nation_3.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin {

  TabController _tabController;
  var tabs = ["效果1", "效果2", "效果3"];
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  Widget _tabbarTitle() {
    return Container(
        child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.blue,
            labelStyle: TextStyle(
              fontSize: 16,
            ),
            indicatorWeight: 2,
            unselectedLabelColor: Colors.grey,
            tabs: tabs.map((tab) {
              return Tab(
                key: Key(tab),
                text: tab,
              );
            }).toList()));
  }

  Widget _tabbarView() {
    return TabBarView(
        controller: _tabController,
        // ignore: missing_return
        children: tabs.map((tab) {
          switch (tab) {
            case "效果1":
              return ChoseNation();
            case "效果2":
              return ChoseNation2();
            case "效果3":
              return ChoseNation3();

          }
        }).toList());
  }


  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("tableView操作指南",),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.white)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Color.fromARGB(10, 0, 0, 0),
                            blurRadius: 2.0,
                            spreadRadius: 4.0)
                      ]),
                  child: _tabbarTitle()),
              Expanded(child: _tabbarView())
            ],
          ),
        ),
      ),

    );
  }
}