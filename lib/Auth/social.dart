import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Auth/login_navigator.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';

class SocialLogIn extends StatefulWidget {
  @override
  _SocialLogInState createState() => _SocialLogInState();
}

class _SocialLogInState extends State<SocialLogIn> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: true,
          ),
        ),
        body: FadedSlideAnimation(
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  Text(
                    AppLocalizations.of(context)!.hey!,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: EntryField(
                      controller: _controller,
                      label: AppLocalizations.of(context)!.mobileNumber,
                      image: 'images/icons/ic_phone.png',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 44.0),
                    child: Text(
                      AppLocalizations.of(context)!.verificationText!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 12.8),
                    ),
                  ),
                ],
              ),
              PositionedDirectional(
                bottom: 0,
                start: 0,
                end: 0,
                child: BottomBar(
                    text: AppLocalizations.of(context)!.continueText,
                    onTap: () {
                      Navigator.pushNamed(context, LoginRoutes.verification);
                    }),
              ),
            ],
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ));
  }
}
