import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:place_picker/entities/entities.dart';

import '../HomeOrderAccount/Account/UI/ListItems/updateaddresses.dart';
import 'LocationProvider.dart';

class SelectPlaceAction extends StatelessWidget {
  final String locationName;
  final String tapToSelectActionText;
  final VoidCallback onTap;

  SelectPlaceAction(this.locationName, this.onTap, this.tapToSelectActionText);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(locationName, style: TextStyle(fontSize: 16)),
                    Text(this.tapToSelectActionText,
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kMainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: onTap,
                child: Text("Continue"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
