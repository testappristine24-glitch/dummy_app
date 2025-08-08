import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem>? barItems;
  final Function? onBarTap;

  AnimatedBottomBar({
    this.barItems,
    this.onBarTap,
  });

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  Duration duration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF158644), // Dark Green
              Color(0xFF65B84C),
            ],
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildBarItems(context),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems(BuildContext context) {
    List<Widget> _barItems = [];
    for (int i = 0; i < widget.barItems!.length; i++) {
      BarItem item = widget.barItems![i];
      bool isSelected = context.watch<StoreProvider>().selectedBarIndex == i;
      _barItems.add(InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          context.read<StoreProvider>().selectedBarIndex = i;
          widget.onBarTap!(context.read<StoreProvider>().selectedBarIndex);
        },
        child: AnimatedContainer(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          duration: duration,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black26 : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Row(
            children: <Widget>[
              ImageIcon(
                AssetImage(item.image!),
                color: Colors.white,
              ),
              SizedBox(width: 10.0),
              AnimatedSize(
                duration: duration,
                curve: Curves.easeInOut,
                child: Text(
                  isSelected ? item.text! : "",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ));
    }
    return _barItems;
  }
}

class BarItem {
  String? text;
  String? image;

  BarItem({this.text, this.image});
}
