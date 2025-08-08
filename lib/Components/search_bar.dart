import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String? hint;
  final Function? onTap;
  final Color? color;
  final BoxShadow? boxShadow;

  CustomSearchBar({
    this.hint,
    this.onTap,
    this.color,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
      decoration: BoxDecoration(
        // border: Border.all(
        //     color: Colors.indigo, width: 1.0, style: BorderStyle.solid),

        boxShadow: [
          boxShadow ?? BoxShadow(color: Theme.of(context).cardColor),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: color ?? Theme.of(context).cardColor,
      ),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: kMainColor,
        readOnly: false,
        decoration: InputDecoration(
          icon: ImageIcon(
            AssetImage('images/icons/ic_search.png'),
            color: Theme.of(context).secondaryHeaderColor,
            size: 16,
          ),
          hintText: hint,
          hintStyle: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: kHintColor),
          border: InputBorder.none,
        ),
        onTap: onTap as void Function()?,
      ),
    );
  }
}
