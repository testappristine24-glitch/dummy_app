import 'dart:io';

import 'package:delivoo/Chat/UI/animated_bottom_bar.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/account_page.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/Stores/allstores.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/home.dart';
import 'package:delivoo/HomeOrderAccount/Order/UI/order_page.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/OrderProvider.dart';
import 'package:delivoo/Providers.dart/banner_provider.dart';
import 'package:delivoo/Providers.dart/login_provider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class HomeOrderAccount extends StatefulWidget {
  @override
  _HomeOrderAccountState createState() => _HomeOrderAccountState();
}

class _HomeOrderAccountState extends State<HomeOrderAccount> {

  @override
  void initState() {
    super.initState();
    context.read<StoreProvider>().onTapped(0);
    Platform.isAndroid ? checkVersion(context) : "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTapped(int index) {
    setState(() {
      context.read<StoreProvider>().currentindex = index;
    });
  }

  static String bottomIconHome = 'images/footermenu/ic_home.png';

  static String bottomIconOrder = 'images/footermenu/ic_orders.png';

  static String bottomIconAccount = 'images/footermenu/ic_profile.png';

  static String allstores = 'images/footermenu/store.png';

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    final List<BarItem> barItems = [
      BarItem(
        text: appLocalization.homeText,
        image: bottomIconHome,
      ),
      BarItem(
        text: 'All Stores',
        image: allstores,
      ),
      BarItem(
        text: appLocalization.orderText,
        image: bottomIconOrder,
      ),
      BarItem(
        text: appLocalization.account,
        image: bottomIconAccount,
      ),
    ];

    final List<Widget> _children = [
      HomePage(),
      AllStores(),
      OrderPage(),
      AccountPage(),
    ];
    return Scaffold(
      body: _children[context.watch<StoreProvider>().currentindex!],
      bottomNavigationBar: Material(
        shadowColor: Colors.amber,
        color: kMainColor,
        child: AnimatedBottomBar(
            barItems: barItems,
            onBarTap: (index) {
              print('??????' + index.toString());
              setState(() {
                context.read<StoreProvider>().currentindex = index;
              });
            }),
      ),
    );
  }
}
