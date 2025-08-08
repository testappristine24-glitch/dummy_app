import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../CommonWidget.dart';
import '../../../../Components/common_app_nav_bar.dart';
import '../../../../Components/common_home_nav_bar.dart';

class SupportPage extends StatefulWidget {
  static const String id = 'support_page';
  final String? number;

  SupportPage({this.number});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  Future<void> _makePhoneCall(String url, scheme) async {
    try {
      await launchUrl(
        Uri(scheme: scheme, path: url),
      );
    } on Exception {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppNavBar(
        titleWidget: Text(AppLocalizations.of(context)!.support!,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white)),
      ),
      body: FadedSlideAnimation(
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 48.0),
                  color: Theme.of(context).cardColor,
                  child: FadedScaleAnimation(
                    child: Image(
                      image: AssetImage(
                          "images/logos/ketransparent.png"), //delivoo logo
                      height: 130.0,
                      width: 99.7,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 16.0),
                        child: Text(
                          AppLocalizations.of(context)!.orWrite!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                        child: Text(
                          AppLocalizations.of(context)!.yourWords!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                      InkWell(
                        excludeFromSemantics: true,
                        canRequestFocus: false,
                        enableFeedback: false,
                        splashFactory: NoSplash.splashFactory,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        overlayColor:
                        MaterialStateProperty.all(Colors.transparent),
                        onTap: () async {

                          var contact = "+917391054206";
                          var androidUrl = "whatsapp://send?phone=$contact";
                          var iosUrl = "https://wa.me/$contact";

                          try{
                            if(Platform.isIOS){
                              await launchUrl(Uri.parse(iosUrl));
                            } else{
                              await launchUrl(Uri.parse(androidUrl));
                            }
                          } on Exception{
                            showMessageDialog(context,
                                'WhatsApp is not installed.');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, top: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child:  EntryField(
                              image: 'images/icons/ic_phone.png',
                              label:
                              'WhatsApp us on', // AppLocalizations.of(context)!.mobileNumber,
                              initialValue: '+91 739 105 4206',
                              readOnly: true,
                              enabled: false,
                              suffixIcon: IconButton(
                                icon:  ImageIcon(
                                  AssetImage('images/icons/icon_whatsapp.png'),
                                  color: Colors.green,
                                ),
                                onPressed: () async {

                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0),

                      InkWell(
                        excludeFromSemantics: true,
                        canRequestFocus: false,
                        enableFeedback: false,
                        splashFactory: NoSplash.splashFactory,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        overlayColor:
                        MaterialStateProperty.all(Colors.transparent),
                        onTap: () async {

                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'customer.care@kisanserv.com',
                            queryParameters: {
                              'subject': '',
                            },
                          );

                          try {
                            if (await canLaunch(emailLaunchUri.toString())) {
                              await launch(emailLaunchUri.toString());
                            } else {
                              throw 'Could not launch email client';
                            }
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, top: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child:  EntryField(
                              image: 'images/icons/ic_mail.png',
                              label:
                              'Email us at', // AppLocalizations.of(context)!.message,
                              hint: AppLocalizations.of(context)!.enterMessage,
                              initialValue: 'customer.care@kisanserv.com',
                              readOnly: true,
                              enabled: false,
                              maxLines: 5,
                              suffixIcon: IconButton(
                                icon: ImageIcon(
                                  AssetImage('images/icons/icon_email.png'),
                                  color: Colors.green, // Optionally set the color
                                ),
                                onPressed: () async {

                                  print("MAHESH CLICK EMAIL");
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 34,
                ),
              ],
            ),
            // PositionedDirectional(
            //   bottom: 0,
            //   start: 0,
            //   end: 0,
            //   child: BottomBar(
            //     text: AppLocalizations.of(context)!.submit,
            //     onTap: () {
            //       /*............*/
            //     },
            //   ),
            // ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
