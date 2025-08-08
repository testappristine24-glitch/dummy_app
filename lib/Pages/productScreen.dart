import 'package:flutter/material.dart';

List<String> categories = ["a", "b", "c", "d", "e", "f", "g", "h"];

class TabsDemo extends StatefulWidget {
  @override
  _TabsDemoState createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo> {
  // TabController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    return DefaultTabController(
        length: categories.length,
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text("Title"),
              bottom: new TabBar(
                isScrollable: true,
                tabs: List<Widget>.generate(categories.length, (int index) {
                  print(categories[0]);
                  return new Tab(
                      icon: Icon(Icons.directions_car),
                      text: categories[index]);
                }),
              ),
            ),
            body: new TabBarView(
              children: List<Widget>.generate(categories.length, (int index) {
                print(categories[0]);
                return new Text(categories[index]);
              }),
            )));
  }
}
