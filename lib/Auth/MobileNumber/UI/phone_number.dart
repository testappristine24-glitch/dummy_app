import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Auth/MobileNumber/UI/mobile_input.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../geo/LocationProvider.dart';

//first page that takes phone number as input for verification
class PhoneNumber extends StatefulWidget {
  static const String id = 'phone_number';

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  @override
  void initState() {
    super.initState();
    context.read<LocationServiceProvider>().getLocationAccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadedSlideAnimation(
        child: ListView(
          children: <Widget>[
            Image.asset("images/logos/kisanserv.gif"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: MobileInput(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                AppLocalizations.of(context)!.verificationText!,
                style: Theme.of(context).textTheme.headlineSmall!
                    .copyWith(fontSize: 12.8),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Using the App indicates ",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () async {
                    final url = Uri.parse(
                        'https://www.kisanserv.com/termsandconditionsnew.aspx');
                    try {
                      launchUrl(url);
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Text(
                      "Acceptance of Terms and Conditions & Terms of Service",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
