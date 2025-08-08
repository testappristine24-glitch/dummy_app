import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';

class TncPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text(AppLocalizations.of(context)!.tnc!,
            style: Theme.of(context).textTheme.bodyLarge),
      ),
      body: FadedSlideAnimation(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(48.0),
                  color: Theme.of(context).cardColor,
                  child: Image(
                    image:
                        AssetImage("images/logos/logo_user.png"), //delivoo logo
                    height: 130.0,
                    width: 99.7,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.termsOfUse!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        AppLocalizations.of(context)!.aboutBody!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        AppLocalizations.of(context)!.companyPolicy!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        AppLocalizations.of(context)!.aboutBody!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
