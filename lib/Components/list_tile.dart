import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';

class BuildListTile extends StatelessWidget {
  final String? image;
  final String? text;
  final Function? onTap;
  final Widget? widget;

  BuildListTile({this.image, this.text, this.onTap, this.widget});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      leading: FadedScaleAnimation(
        child: image != null
            ? Image.asset(
                image!,
                height: 25.3,
              )
            : widget!,
      ),
      title: Text(
        text!,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.07),
      ),
      onTap: onTap as void Function()?,
    );
  }
}
