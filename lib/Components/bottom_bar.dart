import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomBar extends StatelessWidget {
  final Function onTap;
  final String? text;
  final Color? color;
  final Color? textColor;

  BottomBar(
      {required this.onTap, required this.text, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF158644), // Dark Green
              Color(0xFF65B84C),
            ],
          ),
          boxShadow: [],
        ),
        child: Center(
          child: Text(text!,
              style: textColor != null
                  ? bottomBarTextStyle.copyWith(color: textColor)
                  : bottomBarTextStyle),
        ),
        height: 60.0,
      ),
    );
  }
}
