// ignore_for_file: unused_field, unused_element

// import 'package:delivoo/HomeOrderAccount/Order/UI/feedback.dart';
import 'package:delivoo/Pages/Coupon/coupon_page.dart';
import 'package:flutter/material.dart';
import 'package:delivoo/Themes/colors.dart';

import 'package:provider/provider.dart';

import '../../Components/common_app_nav_bar.dart';
import '../../Components/common_home_nav_bar.dart';
import '../../Providers.dart/ProductProvider.dart';

class CouponTab extends StatefulWidget {
  @override
  _CouponTabState createState() => _CouponTabState();
}

class _CouponTabState extends State<CouponTab>
    with SingleTickerProviderStateMixin {
  int? tabIndex;

  TabController? _tabcontroller;

  @override
  void dispose() {
    super.dispose();
    // _anchoredBanner?.dispose();
  }

  @override
  void initState() {
    _tabcontroller = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    context.read<ProductProvider>().loadCoupons(action: "3");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          right: true,
          left: true,
          bottom: true,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: CommonAppNavBar(
                // automaticallyImplyLeading: true,
                titleWidget: Text('Coupons',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white)),
                actions: [],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0.0),
                  child: TabBar(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabcontroller,
                    onTap: (value) {
                      context
                          .read<ProductProvider>()
                          .loadCoupons(action: value == 0 ? "3" : "4");
                      setState(() {});
                      print('tabvalue------' + value.toString());
                      tabIndex = value;
                    },
                    tabs: List.generate(
                      2,
                      (index) => Container(
                        child: Tab(
                          child: Text(
                            index == 0 ? 'Offer Coupons' : 'Referral Coupons',
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    isScrollable: true,
                    labelColor: kWhiteColor,
                    unselectedLabelColor: Colors.black,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabcontroller,
              children: List.generate(2, (int index) {
                return RefreshIndicator(
                    color: kMainColor,
                    onRefresh: () {
                      return context
                          .read<ProductProvider>()
                          .loadCoupons(action: index == 0 ? "3" : "4");
                    },
                    child: CouponScreen(
                      refferal: index == 0 ? false : true,
                    ));
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
