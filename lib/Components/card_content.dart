import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {

  final String? text;
  final dynamic image;

  CardContent({this.text, this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 6,
          child: Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Container(decoration: BoxDecoration(image: image!)),
          ),
        ),
        Expanded(
          flex:2,
          child: Text(
            maxLines: 2,
            text.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(letterSpacing: 0.05),
          ),
        ),
      ],
    );
  }
}
