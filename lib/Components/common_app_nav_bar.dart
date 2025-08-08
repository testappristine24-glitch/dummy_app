import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonAppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget titleWidget;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPress;
  final bool showBackButton;

  const CommonAppNavBar({
    Key? key,
    required this.titleWidget,
    this.actions,
    this.bottom,
    this.onBackPress,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: AppBar(
        backgroundColor: Colors.transparent, // Ensures the gradient is visible
        elevation: 0, // Removes default shadow
        titleSpacing: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: titleWidget,
        actions: actions,
        bottom: bottom ??
            PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Container(),
            ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
