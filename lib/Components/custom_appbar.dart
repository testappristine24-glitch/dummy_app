import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Function? onTap;
  final String? hint;
  final PreferredSizeWidget? bottom;
  final Color? color;
  final BoxShadow? boxShadow;

  CustomAppBar({
    this.titleWidget,
    this.actions,
    this.leading,
    this.onTap,
    this.hint,
    this.bottom,
    this.color,
    this.boxShadow,
  });

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
        boxShadow: boxShadow != null ? [boxShadow!] : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Allows dynamic height adjustment
        children: [
          AppBar(
            backgroundColor: Colors.transparent, // Gradient remains visible
            elevation: 0, // Removes shadow if using boxShadow separately
            titleSpacing: 0.0,
            leading: leading ??
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
            title: titleWidget,
            actions: actions,
          ),
          if (bottom != null) bottom!, // Adds bottom dynamically
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    double bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + bottomHeight); // Dynamically adjust size
  }
}
