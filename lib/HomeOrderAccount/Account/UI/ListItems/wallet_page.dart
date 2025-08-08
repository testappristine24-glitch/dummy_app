import 'dart:math';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/Payment_provider.dart';
import 'package:delivoo/Providers.dart/login_provider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../../../Components/common_app_nav_bar.dart';
import '../../../../Components/common_home_nav_bar.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppNavBar(
        titleWidget: Text(AppLocalizations.of(context)!.wallet!,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
        actions: [

        ],
      ),
      body: FadedSlideAnimation(
        child: Wallet(),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

class Wallet extends StatefulWidget {
  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    final profile = context.watch<LoginProvider>().profile?.d;
    final walletdetails = context.watch<Paymentprovider>().walletdetails?.d;
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ListTile(
              title: Text(
                AppLocalizations.of(context)!.availableBalance!.toUpperCase(),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    letterSpacing: 0.67,
                    color: kHintColor,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                '\u{20B9} ${profile?[0].walletamt ?? ''}',
                style: listTitleTextStyle.copyWith(
                    fontSize: 35.0, color: kMainColor, letterSpacing: 0.18),
              ),
            ),
          ),
        ),
        Container(
          height: 40.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          color: Theme.of(context).cardColor,
          child: Text(
            AppLocalizations.of(context)!.recent!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: kTextColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.08),
          ),
        ),
        walletdetails != null
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.62,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: walletdetails.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Transform.rotate(
                                child: Icon(Icons.arrow_downward,
                                    color:
                                        walletdetails[index].debitamount == ''
                                            ? Colors.green
                                            : Colors.red),
                                angle: walletdetails[index].debitamount == ''
                                    ? 45 * pi / 180
                                    : 225 * pi / 180,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      walletdetails[index]
                                          .transactiondetails
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10.0),
                                  Text(
                                      //'30 June 2018, 11.59 am',
                                      walletdetails[index]
                                          .transactiondate
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              color: kTextColor,
                                              fontSize: 11.7)),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    // '\$21.00',
                                    walletdetails[index].creditamount != ''
                                        ? '+ \u{20B9} ${walletdetails[index].creditamount}'
                                        : '- \u{20B9} ${walletdetails[index].debitamount}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: walletdetails[index]
                                                        .creditamount ==
                                                    ''
                                                ? Color(0xffe32a2a)
                                                : Colors.green),
                                  ),
                                  SizedBox(height: 10.0),
                                  // Text('3 items',
                                  //     style: Theme.of(context)
                                  //         .textTheme
                                  //         .headlineSmall!
                                  //         .copyWith(
                                  //             color: kTextColor, fontSize: 11.7)),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: Theme.of(context).cardColor,
                            thickness: 3.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
