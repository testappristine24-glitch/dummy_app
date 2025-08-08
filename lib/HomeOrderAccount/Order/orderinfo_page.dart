// ignore_for_file: deprecated_member_use, unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo/Components/custom_appbar.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/OrderProvider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../AppConstants.dart';

class OrderInfo extends StatefulWidget {
  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  int current_step = 0;
  List<Step> steps = [
    Step(
      title: Text('Step 1'),
      content: Text('Order Placed'),
      isActive: false,
    ),
    Step(
      title: Text('Step 2'),
      content: Text('Packed and ready'),
      isActive: true,
    ),
    Step(
      title: Text('Step 3'),
      content: Text('Picked'),
      state: StepState.complete,
      isActive: true,
    ),
    Step(
      title: Text('Step 4'),
      content: Text('Delivered'),
      state: StepState.complete,
      isActive: true,
    ),
  ];
  @override
  @override
  void initState() {
    super.initState();
  }

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
    final orderdetails = context.watch<Orderprovider>().orderdetails?.d;
    final selectedorder = context.watch<Orderprovider>().selectedOrder;
    if (selectedorder?.orderStatus == "Submitted and Paid") {
      current_step = 1;
    } else if (selectedorder?.orderStatus == "Packed and Ready") {
      current_step = 2;
    } else if (selectedorder?.orderStatus == "Out for Delivery") {
      current_step = 3;
    } else if (selectedorder?.orderStatus == "Delivered") {
      current_step = 4;
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(300.0),
        child: CustomAppBar(
          leading: null,
          titleWidget: Text(
            'Order Details',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 20, letterSpacing: 0.07, color: Colors.white),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: Hero(
              tag: 'Customer',
              child: Container(
                color: Theme.of(context).cardColor,
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  title: Column(
                    children: [
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              afterLineStyle: current_step > 1
                                  ? LineStyle(color: Colors.green)
                                  : LineStyle(color: Colors.grey),
                              lineXY: 0.5,
                              isFirst: true,
                              indicatorStyle: IndicatorStyle(
                                  indicator: Icon(Icons.circle,
                                      color: current_step > 0
                                          ? Colors.green
                                          : Colors.grey),
                                  width: 10),
                              startChild: Container(
                                child: Center(
                                  child: Text("Submitted and Paid",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold)),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 70,
                                ),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 70,
                                ),
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              indicatorStyle: IndicatorStyle(
                                  indicator: Icon(Icons.circle,
                                      color: current_step > 1
                                          ? Colors.green
                                          : Colors.grey),
                                  width: 10),
                              beforeLineStyle: current_step > 1
                                  ? LineStyle(color: Colors.green)
                                  : LineStyle(color: Colors.grey),
                              afterLineStyle: current_step > 2
                                  ? LineStyle(color: Colors.green)
                                  : LineStyle(color: Colors.grey),
                              lineXY: 0.5,
                              //hasIndicator: false,
                              startChild: Container(
                                child: Center(
                                  child: Text("Packed and Ready",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold)),
                                ),
                                width: 100,
                                constraints: const BoxConstraints(
                                  minWidth: 70,
                                ),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 70,
                                ),
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              indicatorStyle: IndicatorStyle(
                                  indicator: Icon(Icons.circle,
                                      color: current_step > 2
                                          ? Colors.green
                                          : Colors.grey),
                                  width: 10),
                              beforeLineStyle: current_step > 2
                                  ? LineStyle(color: Colors.green)
                                  : LineStyle(color: Colors.grey),
                              afterLineStyle: current_step > 3
                                  ? LineStyle(color: Colors.green)
                                  : LineStyle(color: Colors.grey),
                              lineXY: 0.5,
                              //hasIndicator: false,
                              startChild: Container(
                                child: Center(
                                  child: Text("Out for Delivery",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold)),
                                ),
                                width: 100,
                                constraints: const BoxConstraints(
                                  minWidth: 50,
                                ),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 50,
                                ),
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              beforeLineStyle: current_step > 3
                                  ? LineStyle(color: Colors.green)
                                  : LineStyle(color: Colors.grey),
                              lineXY: 0.5,
                              isLast: true,
                              indicatorStyle: IndicatorStyle(
                                  indicator: Icon(Icons.circle,
                                      color: current_step > 3
                                          ? Colors.green
                                          : Colors.grey),
                                  width: 10),
                              startChild: Container(
                                child: Center(
                                  child: Text("Delivered",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold)),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 50,
                                ),
                              ),
                              endChild: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Customer name : ${selectedorder?.customerName}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(fontSize: 15.3, letterSpacing: 0.07),
                          ),
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.phone,
                          //     color: kMainColor,
                          //     size: 18.0,
                          //   ),
                          //   onPressed: () {
                          //     // _makePhoneCall(selectedItems.mobileNo, 'tel');
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderDetails(
                          context, 'Order Date:', selectedorder?.orderDate),
                      orderDetails(
                          context, 'Delivery Date:', selectedorder?.deliverydate),
                      orderDetails(
                          context, 'Total Products:', selectedorder?.qty),
                      orderDetails(
                          context,
                          'Order Weight:',
                          double.parse(selectedorder!.wt!)
                                  .toStringAsFixed(2)
                                  .replaceFirst(RegExp(r'\.?0*$'), '') +
                              " Kg"),
                      orderDetails(context, 'Order No:', selectedorder.orderNo),
                      orderDetails(context, 'Order Value:',
                          '\u{20B9} ${selectedorder.totalamount}'),
                      orderDetails(
                          context,
                          'Payment Status:',
                          selectedorder.paymentStatus == "1"
                              ? "Paid"
                              : "Not Paid"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Divider(
                //   color: kCardBackgroundColor,
                //   thickness: 8.0,
                // ),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Text(
                      //AppLocalizations.of(context)!.item!,
                      'ITEM(S)',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Color(0xffadadad),
                          fontWeight: FontWeight.bold)),
                  //color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orderdetails?.length ?? 0,
                      itemBuilder: (context, index) {
                        final items = orderdetails?[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              dense: true,
                              leading: Container(
                                width: 50.0,
                                decoration: BoxDecoration(
                                  image: items!.imagename != null
                                      ? DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              BaseUrl +
                                                  'skuimages/' +
                                                  items.imagename!,
                                              cacheKey: items.imagename
                                              // fit: BoxFit.cover,
                                              ),
                                          onError: (exception, stackTrace) {
                                            items.imagename = null;
                                          },
                                        )
                                      : DecorationImage(
                                          image: AssetImage(
                                            'images/logos/not-available.png',
                                          ),
                                        ),
                                ),
                              ),
                              title: Text(
                                items.itemName.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Qty: ${double.parse(items.qty!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    '\u{20B9} ${double.parse(items.totalamount!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '\u{20B9} ${double.parse(items.itemRate!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: kCardBackgroundColor,
                              thickness: 1.0,
                            ),
                          ],
                        );
                      }),
                ),
                // Divider(
                //   color: kCardBackgroundColor,
                //   thickness: 8.0,
                // ),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Text(
                      //AppLocalizations.of(context)!.payment!,
                      'Payment',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: kDisabledColor, fontWeight: FontWeight.bold)),
                  //color: Colors.white,
                ),
                Container(
                  // color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Delivery charges',
                            style: Theme.of(context).textTheme.bodyMedium!),
                        Text(
                          '\u{20B9} ${selectedorder.deliveryCharge}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ]),
                ),
                Container(
                  //color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.sub!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\u{20B9} ${selectedorder.totalamount}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ]),
                ),

                Divider(
                  color: kCardBackgroundColor,
                  thickness: 1.0,
                ),
                Container(
                  // color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Paid',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold, color: kMainColor),
                        ),
                        Text(
                          '\u{20B9} ${selectedorder.totalamount}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ]),
                ),
                Divider(
                  color: kCardBackgroundColor,
                  thickness: 1.0,
                ),
                // Container(
                //   color: Colors.white,
                //   padding:
                //       EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: <Widget>[
                //         Text(
                //           "Total Saving",
                //           style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                //               fontWeight: FontWeight.bold, color: kMainColor),
                //         ),
                //         Text(
                //           '\₹ ${100}',
                //           style: Theme.of(context).textTheme.bodyMedium,
                //         ),
                //       ]),
                // ),
                SizedBox(
                  height: 7.0,
                ),
                Container(height: 50.0, color: Theme.of(context).cardColor),
              ],
            ),
          ),
          // context.read<OrderProvider>().selectedPage == true
          //     ? selectedItems.orderStatus != "Packed and Ready"
          //         ? Align(
          //             alignment: Alignment.bottomCenter,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: <Widget>[
          //                 BottomBar(
          //                     text: AppLocalizations.of(context)!.ready,
          //                     onTap: () async {
          //                       // await context
          //                       //     .read<Orderprovider>()
          //                       //     .readyToPickUp(selectedItems.orderid);
          //                       Navigator.pop(context);
          //                     })
          //               ],
          //             ),
          //           )
          //         : Align(
          //             alignment: Alignment.bottomCenter,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: <Widget>[
          //                 BottomBar(
          //                     color: Colors.green,
          //                     text: selectedItems.orderStatus,
          //                     onTap: () {
          //                       Navigator.pop(context);
          //                     })
          //               ],
          //             ),
          //           )
          //     : Container()
        ],
      ),
    );
  }

  Row orderDetails(BuildContext context, text, selectedOrder) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!
              .copyWith(fontSize: 14, letterSpacing: 0.06),
        ),
        Text(
          '${selectedOrder}',
          style: Theme.of(context).textTheme.bodyMedium!
              .copyWith(fontSize: 14, letterSpacing: 0.06),
        ),
      ],
    );
  }
}
