// ignore_for_file: unused_field, unused_element

import 'dart:io';
import 'package:delivoo/Components/loading_shimmer.dart';
// import 'package:delivoo/HomeOrderAccount/Order/UI/feedback.dart';
import 'package:delivoo/HomeOrderAccount/Order/UI/feedback_page.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Pages/invoice.dart';
import 'package:delivoo/Providers.dart/OrderProvider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Components/common_home_nav_bar.dart';
import '../../../Providers.dart/Address_provider.dart';
import '../../../Routes/routes.dart';
import '../orderinfo_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
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
    context.read<Addressprovider>().setLocationDialog(false); //this is to show new location pop up if value is true it shows the pop up
    _tabcontroller = TabController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
    context.read<Orderprovider>().getorders('', '', '', 1);
    super.initState();
  }

  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse(Platform.isAndroid
        ? "https://www.google.com/maps/search/?api=1&query=$lat,$lng"
        : "maps:q=$lat,$lng&mode=d");
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      throw 'Could not launch $uri';
    }
  }

  Future<void> _makePhoneCall(
    String url,
  ) async {
    try {
      await launchUrl(
        Uri(scheme: 'tel', path: url),
      );
    } on Exception {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<Orderprovider>().orders?.d;
    return Builder(
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            context.read<StoreProvider>().onTapped(0);
            return Future.value(false);
          },
          child: SafeArea(
            top: false,
            right: true,
            left: true,
            bottom: true,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: CommonHomeNavBar(
                  titleWidget: Text(AppLocalizations.of(context)!.orderText!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white)),
                  actions: [
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0.0),
                    child: TabBar(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabcontroller,
                      onTap: (value) {
                        context
                            .read<Orderprovider>()
                            .getorders('', '', '', value);
                        setState(() {});
                        print('tabvalue------' + value.toString());
                        tabIndex = value;
                      },
                      tabs: List.generate(
                        3,
                        (index) => Container(
                          child: Tab(
                            child: Text(
                              index == 0 ? 'Past orders' : index == 1 ? 'Current orders' : 'Next Day orders',
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
              body: context.watch<Orderprovider>().isloading == true
                  ? LoadingShimmer()
                  : orders?.length == 0 || orders == null
                      ? Center(child: Text('No orders found'))
                      : TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabcontroller,
                          children: List.generate(3, (int index) {
                            return RefreshIndicator(
                              color: kMainColor,
                              onRefresh: () {
                                return context
                                    .read<Orderprovider>()
                                    .getorders('', '', '', index);
                              },
                              child: ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  Container(
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: orders.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () async {

                                            if (context
                                                    .read<Orderprovider>()
                                                    .present == 1) {
                                              await context
                                                  .read<Orderprovider>()
                                                  .getorderdetails(
                                                      orders[index].orderid,
                                                      index);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderInfo(),
                                                ),
                                              );
                                            }
                                            else {
                                              await context
                                                  .read<Orderprovider>()
                                                  .getorderdetails(
                                                      orders[index].orderid,
                                                      index);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderInfo(),
                                                ),
                                              );
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: ListTile(
                                                      minVerticalPadding: 10,
                                                      dense: true,
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      title: Text(
                                                        orders[index]
                                                            .orderNo
                                                            .toString(), //AppLocalizations.of(context)!.vegetable!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      subtitle: orders[index].deliverydate.toString() == orders[index].orderDate.toString()
                                                          ? Text('Delivery Date ${orders[index].orderDate.toString()}', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 11.7))
                                                          : Text('Order Date ${orders[index].orderDate.toString()}\nDelivery Date ${orders[index].deliverydate.toString()}', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 11.7)),
                                                      trailing: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            orders[index]
                                                                .orderStatus
                                                                .toString(), //AppLocalizations.of(context)!.deliv!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          SizedBox(height: 7.0),
                                                          Text(
                                                            // '\$ 11.50 | ${AppLocalizations.of(context)!.credit}',
                                                            '\u{20B9}  ${orders[index].totalamount}    ${orders[index].paymentmode}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headlineSmall!
                                                                .copyWith(
                                                                  fontSize:
                                                                      11.7,
                                                                  letterSpacing:
                                                                      0.06, /* color: Color(0xffc1c1c1) */
                                                                ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Divider(
                                                color:
                                                    Theme.of(context).cardColor,
                                                thickness: 1.0,
                                              ),
                                              orders[index].mapAddress ==
                                                          null ||
                                                      orders[index]
                                                              .mapAddress ==
                                                          ""
                                                  ? SizedBox.shrink()
                                                  : Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5.0,
                                                                  horizontal:
                                                                      12.0),
                                                          child: Icon(
                                                            Icons.location_on,
                                                            color: kMainColor,
                                                            size: 13.3,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.49,
                                                          child: Text(
                                                            '${orders[index].mapAddress}' +
                                                                '\t',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                  fontSize:
                                                                      10.0,
                                                                  letterSpacing:
                                                                      0.05,
                                                                ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        context
                                                                    .watch<
                                                                        Orderprovider>()
                                                                    .present ==
                                                                0
                                                            ? Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    // Navigator.pushNamed(
                                                                    //     context,
                                                                    //     PageRoutes.rate);
                                                                  },
                                                                  child: Text(
                                                                    // AppLocalizations.of(
                                                                    //         context)!
                                                                    //     .rate!,
                                                                    '',
                                                                    style: orderMapAppBarTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kMainColor),
                                                                  ),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        18.0),
                                                                child: Text(
                                                                  'View Details',
                                                                  style: orderMapAppBarTextStyle
                                                                      .copyWith(
                                                                      color:
                                                                      kMainColor),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  orders[index].delboyMobile ==
                                                              null ||
                                                          orders[index]
                                                                  .delboyMobile ==
                                                              ""
                                                      ? SizedBox.shrink()
                                                      : InkWell(
                                                          onTap: () async {
                                                            await _makePhoneCall(
                                                                orders[index]
                                                                    .delboyMobile
                                                                    .toString());
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5.0,
                                                                        horizontal:
                                                                            12.0),
                                                                child: Icon(
                                                                  Icons.phone,
                                                                  color:
                                                                      kMainColor,
                                                                  size: 13.3,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Delboy No. -",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                      fontSize:
                                                                          11.0,
                                                                      letterSpacing:
                                                                          0.05,
                                                                    ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.20,
                                                                child: Text(
                                                                  orders[index]
                                                                      .delboyMobile
                                                                      .toString(),
                                                                  style: Theme
                                                                          .of(
                                                                              context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.05,
                                                                          color:
                                                                              Colors.red),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  Spacer(),
                                                ],
                                              ),
                                              orders[index].orderPin != null &&
                                                      orders[index].orderPin !=
                                                          ""
                                                  ? Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5.0,
                                                                  horizontal:
                                                                      12.0),
                                                          child: Icon(
                                                            Icons.pin_outlined,
                                                            color: kMainColor,
                                                            size: 13.3,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Delivery Code -",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        11.0,
                                                                    letterSpacing:
                                                                        0.05,
                                                                  ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                          child: Text(
                                                            orders[index]
                                                                .orderPin
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    fontSize:
                                                                        12.0,
                                                                    letterSpacing:
                                                                        0.05,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox.shrink(),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 12.0),
                                                    child: Icon(
                                                      Icons.navigation,
                                                      color: kMainColor,
                                                      size: 13.3,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.50,
                                                    child: Text(
                                                      orders[index]
                                                          .delAddress
                                                          .toString(), //'\t(Central Residency)',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.05),
                                                      // overflow:
                                                      //     TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  tabIndex == 0
                                                      ? SizedBox.shrink()
                                                      : Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5.0,
                                                                      horizontal:
                                                                          12.0),
                                                              child: Icon(
                                                                Icons
                                                                    .watch_later_outlined,
                                                                color:
                                                                    kMainColor,
                                                                size: 13.3,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: orders[index]
                                                                          .deltype ==
                                                                      '2'
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.30
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.48,
                                                              child: Text(
                                                                orders[index]
                                                                            .deltype ==
                                                                        '2'
                                                                    ? 'In-store pick-up'
                                                                    : 'Slot Time :${orders[index].delstarttime.toString()} - ${orders[index].delendtime.toString()}', //'\t(Central Residency)',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.05),
                                                              ),
                                                            ),
                                                            orders[index]
                                                                        .deltype ==
                                                                    '2'
                                                                ? IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      navigateTo(
                                                                          double.parse(orders[index]
                                                                              .shoplatitude!),
                                                                          double.parse(
                                                                              orders[index].shoplongitude!));
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .directions))
                                                                : Container(),
                                                          ],
                                                        ),
                                                  Spacer(),
                                                  SizedBox(),
                                                  Row(
                                                    children: [
                                                      tabIndex == null ||
                                                              tabIndex == 1 || tabIndex == 2
                                                          ? SizedBox()
                                                          : orders[index].ratingStatus == "1"
                                                              ? Row()
                                                              : Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.0),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          await context
                                                                              .read<StoreProvider>()
                                                                              .getfeedbackquestion();
                                                                          await context
                                                                              .read<StoreProvider>()
                                                                              .getfeedbackquestions();
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => feedbackScreen(orderid: orders[index].orderid),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              48,
                                                                          // decoration: BoxDecoration(
                                                                          //     borderRadius: BorderRadius.circular(10),
                                                                          //     color: kMainColor,
                                                                          //     border: Border.all(
                                                                          //       color: kMainColor,
                                                                          //     )),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(3.0),
                                                                              // child: Text(
                                                                              //   "",
                                                                              //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, color: kWhiteColor),
                                                                              // )
                                                                              child: Image.asset(
                                                                                "images/icons/fb3.png",
                                                                                height: 40.3,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 18.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          print(orders[index]
                                                              .orderid);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Invoice(orders[
                                                                          index]
                                                                      .orderid),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: kMainColor,
                                                            border: Border.all(
                                                              color: kMainColor,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Text(
                                                                "View Invoice",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            kWhiteColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ) /*  : Container() */,
                                              Divider(
                                                color: Colors
                                                    .black, //Theme.of(context).cardColor,
                                                thickness: 1,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
            ),
          ),
        );
      },
    );
  }
}
