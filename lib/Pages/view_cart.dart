// ignore_for_file: unused_field, deprecated_member_use, unused_local_variable
import 'dart:math';

import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:delivoo/AppConstants.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Components/common_app_nav_bar.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Pages/paymentselection.dart';
import 'package:delivoo/Providers.dart/Address_provider.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/custom_appbar.dart';
import '../main.dart';
import 'Coupon/coupon_page.dart';

List<DropdownMenuItem<String>> listDrop = [];
int? selected;
int? selected1;

bool? isSelectedSlot = false;

void loadData() {
  listDrop = [];
  listDrop.add(DropdownMenuItem(
    child: Text('1 kg'),
    value: 'A',
  ));
  listDrop.add(DropdownMenuItem(
    child: Text('500 g'),
    value: 'B',
  ));
  listDrop.add(DropdownMenuItem(
    child: Text('250 g'),
    value: 'C',
  ));
}

class ViewCart extends StatefulWidget {
  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  int? group;
  var pickup;
  var isOpen;
  int x = 0;
  var _razorpay = Razorpay();
  var checkout;
  final ScrollController _scrollController = ScrollController();
  // late ConfettiController _confettiControllerLeft;
  // late ConfettiController _confettiControllerRight;
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    isSelectedSlot = false;
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("warehouseid ${prefs.getString("warehouseid")}");
      await context.read<StoreProvider>().gettimeslots();
      context.read<StoreProvider>().selectedtimeslot = null;
    });

    //context.read<StoreProvider>().gettimeslots();
    _scrollController.addListener(() {});
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerCenter.dispose();
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final cartitems = context.watch<ProductProvider>().cartitems?.d;
    checkout = context.watch<ProductProvider>().cartTotal?.d;
    final timeslots = context.watch<StoreProvider>().timeslots?.d;
    if (context.watch<StoreProvider>().selectedstore != null) {
      group = int.parse(context.watch<StoreProvider>().selectedstore!.deltype!);
      pickup = context.watch<StoreProvider>().selectedstore!.Instorepickup;
      isOpen = context.watch<StoreProvider>().selectedstore!.isOpen;
    }

    //loadData();
    return WillPopScope(
      onWillPop: () async {
        if (cartitems != null &&
            cartitems.length != 0 &&
            context.read<ProductProvider>().products?.d != null) {
          await context.read<ProductProvider>().mapcartwithproducts();
        }
        print('going back');
        return Future.value(true);
      },
      child: Scaffold(
        appBar: CommonAppNavBar(
          titleWidget: Text(AppLocalizations.of(context)!.confirm!,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white)),
        ),
        body: cartitems?.length != 0 && cartitems != null && checkout != null
            ? Stack(
                children: <Widget>[
                  ListView(
                    controller: _scrollController,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                        color: Theme.of(context).cardColor,
                        child: Text('CART',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(letterSpacing: 0.67)),
                      ),
                      cartitems.length != 0 && cartitems.isNotEmpty
                          ? ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: cartitems.length,
                              itemBuilder: (context, index) {
                                return cartOrderItemListTile(
                                    context,
                                    cartitems[index].productImage.toString(),
                                    cartitems[index]
                                        .productName
                                        .toString(), //AppLocalizations.of(context)!.onion!,
                                    cartitems[index]
                                        .productRate
                                        .toString(), //'3.00',
                                    cartitems[index].productQty!, // _itemCount,
                                    cartitems[index].productWeight!,
                                    () => context
                                        .read<ProductProvider>()
                                        .decreaseCountincart(index),
                                    cartitems[index].productQty! <
                                            cartitems[index].productStock!
                                        ? () => context
                                            .read<ProductProvider>()
                                            .increaseCountincart(index)
                                        : () {
                                            showMessage(
                                                'Only ${cartitems[index].productStock} left in stock');
                                          },
                                    () => context
                                        .read<ProductProvider>()
                                        .removefromcart(index),
                                    cartitems[index].productMrp!,
                                    cartitems[index].totalamount!,
                                    cartitems[index].isloading!);
                              },
                            )
                          : Container(),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 1.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Item Count : ${cartitems.length}',
                                style: Theme.of(context).textTheme.bodyMedium),
                            Text(
                                cartitems.isNotEmpty
                                    ? 'Total no. of items : ${context.watch<ProductProvider>().numberOfItems}'
                                    : 'Total no. of items : 0',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Container(
                        height: 53.3,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            InkWell(
                              onTap: () {
                                if (cartitems.length != 0 &&
                                    cartitems.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => new AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: Text(
                                        'All products from the cart will be removed',
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<ProductProvider>()
                                                .removeallProducts();
                                            Navigator.pop(context);
                                          },
                                          child: Text("Continue"),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  showMessage('No items in cart');
                                }
                              },
                              child: /* Icon(
                          Icons.remove_shopping_cart,
                          color: kMainColor,
                          size: 20.0,
                          //size: 23.3,
                        ), */
                                  Text(
                                'Remove all',
                                style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 0.05,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 6.7,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Center(
                          child: Text(
                              AppLocalizations.of(context)!
                                  .paymentInfo!
                                  .toUpperCase(),
                              style: Theme.of(context).textTheme.headlineSmall!),
                        ),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.sub!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 12),
                              ),
                              cartitems.isNotEmpty
                                  ? Text(
                                      '\u{20B9} ${checkout[0].subtotal}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 12),
                                    )
                                  : Text(
                                      '\u{20B9} 0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 12),
                                    )
                            ]),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 1.0,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Delivery charges',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 12),
                              ),
                              Text(
                                cartitems.isNotEmpty
                                    ? '\u{20B9} ${checkout[0].delcharge}'
                                    : '\u{20B9} 0',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 12),
                              ),
                            ]),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 1.0,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Savings',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 12),
                              ),
                              cartitems.isNotEmpty
                                  ? Text(
                                      '\u{20B9} ${checkout[0].savingamount}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 12),
                                    )
                                  : Text(
                                      '\u{20B9} 0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 12),
                                    )
                            ]),
                      ),
                      checkout[0].couponamt == null ||
                              checkout[0].couponamt == "0.00" ||
                              checkout[0].couponamt == "0" ||
                              checkout[0].couponamt == ""
                          ? SizedBox.shrink()
                          : Divider(
                              color: Theme.of(context).cardColor,
                              thickness: 1.0,
                            ),
                      checkout[0].couponamt == null ||
                              checkout[0].couponamt == "0.00" ||
                              checkout[0].couponamt == "0" ||
                              checkout[0].couponamt == ""
                          ? SizedBox.shrink()
                          : Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 20.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Coupon",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 12),
                                    ),
                                    // Spacer(),
                                    // Text(
                                    //   checkout![0].couponName ?? "Coupon",
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .bodyMedium!
                                    //       .copyWith(fontSize: 12),
                                    // ),
                                    Spacer(),
                                    cartitems.isNotEmpty
                                        ? Text(
                                            '\u{20B9} ${checkout[0].couponamt == null ? "0.00" : checkout[0].couponamt}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(fontSize: 12),
                                          )
                                        : Text(
                                            '\u{20B9} 0',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(fontSize: 12),
                                          ),
                                  ]),
                            ),
                      checkout[0].dicountamt == null ||
                              checkout[0].dicountamt == "0.00" ||
                              checkout[0].dicountamt == "" ||
                              checkout[0].dicountamt == "0"
                          ? SizedBox.shrink()
                          : Divider(
                              color: Theme.of(context).cardColor,
                              thickness: 1.0,
                            ),
                      checkout[0].dicountamt == null ||
                              checkout[0].dicountamt == "0.00" ||
                              checkout[0].dicountamt == "" ||
                              checkout[0].dicountamt == "0"
                          ? SizedBox.shrink()
                          : Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 20.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Discount',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 12),
                                    ),
                                    Spacer(),
                                    cartitems.isNotEmpty
                                        ? Text(
                                            ' ${checkout[0].dicountper == null || checkout[0].dicountper == "" ? "" : '@${checkout[0].dicountper} %'} ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(fontSize: 12),
                                          )
                                        : Text(
                                            '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(fontSize: 12),
                                          ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    cartitems.isNotEmpty
                                        ? Text(
                                            '\u{20B9} ${checkout[0].dicountamt == null ? "0.00" : checkout[0].dicountamt}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(fontSize: 12),
                                          )
                                        : Text(
                                            '\u{20B9} 0',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(fontSize: 12),
                                          ),
                                  ]),
                            ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 1.0,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Wallet',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 12),
                              ),
                              cartitems.isNotEmpty &&
                                      checkout[0].walletamt != ''
                                  ? Text(
                                      '\u{20B9} ${checkout[0].walletamt}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 12),
                                    )
                                  : Text(
                                      '\u{20B9} 0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 12),
                                    )
                            ]),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 6.7,
                      ),
                      checkout[0].couponName == null ||
                              checkout[0].couponName == "0.00" ||
                              checkout[0].couponName == "0" ||
                              checkout[0].couponName == ""
                          ? InkWell(
                              onTap: () async {
                                var res = await context
                                    .read<ProductProvider>()
                                    .loadCoupons(action: "2");
                                res == "sucess"
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CouponScreen(app_Bar: true),
                                        ),
                                      )
                                    : null;
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: 8.0, left: 8.0, top: 3),
                                height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.lightGreen, // border color
                                    width: 1,           // border width
                                  ),
                                  borderRadius: BorderRadius.circular(5), // optional: adds rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text("View all Coupons",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                          color: kMainColor,
                                        )
                                      ]),
                                ),
                              )
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, left: 8.0, top: 3),
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 3.0, left: 3.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: 3.0, left: 3.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.72,
                                                height: 45,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.verified_outlined,
                                                      color: Colors.blue,
                                                      size: 18,
                                                    ),
                                                    Text(
                                                      checkout[0]
                                                          .couponName
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: kMainColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    "Applied",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: kMainColor,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      Divider(),
                                      InkWell(
                                        onTap: () async {
                                          var res = await context
                                              .read<ProductProvider>()
                                              .loadCoupons(action: "2");
                                          res == "sucess"
                                              ? Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CouponScreen(
                                                            app_Bar: true),
                                                  ),
                                                )
                                              : null;
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: 8.0,
                                            left: 8.0,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.lightGreen, // border color
                                                  width: 1,           // border width
                                              ),
                                              borderRadius: BorderRadius.circular(5), // optional: adds rounded corners
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Text("View all Coupons",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!),
                                                    Spacer(),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 18,
                                                      color: kMainColor,
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 6.7,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.amount!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                              ),
                              Text(
                                cartitems.isNotEmpty
                                    ? '\u{20B9} ${(double.parse(checkout[0].posttaxamount!) - double.parse(checkout[0].couponamt == "" ? "0.0" : checkout[0].couponamt.toString()))}'
                                    : '\u{20B9} 0',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      isOpen == '1' && pickup == '1'
                          ? Opacity(
                              opacity: 1,
                              child: ListTile(
                                //tileColor: Colors.green,
                                selectedTileColor: Colors.red,
                                trailing: Switch(
                                    activeColor: buttonColor,
                                    inactiveThumbColor: Colors.black,
                                    inactiveTrackColor: Colors.grey.withOpacity(0.5),
                                    value: context
                                        .watch<ProductProvider>()
                                        .instorepickup!,
                                    onChanged: (value) {
                                      context
                                              .read<ProductProvider>()
                                              .instorepickup =
                                          !(context
                                              .read<ProductProvider>()
                                              .instorepickup!);

                                      setState(() {

                                      });
                                      context
                                          .read<ProductProvider>()
                                          .getcarttotal();
                                      //context.read<StoreProvider>().refresh();
                                    }),
                                title: Text(
                                  'In-store pick-up',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                          : Container(),
                      context.watch<ProductProvider>().instorepickup == false
                          ? Opacity(
                              opacity: group == 1 ? 0.3 : 1,
                              child: RadioListTile(
                                  activeColor: buttonColor,
                                  //tileColor: Colors.green,
                                  selectedTileColor: Colors.red,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  title: Text(
                                    'Quick Delivery',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  value: 0,
                                  groupValue: group,
                                  onChanged: (value) {
                                    setState(() {
                                      group = value as int?;
                                    });
                                  }),
                            )
                          : Container(),
                      context.watch<ProductProvider>().instorepickup == false
                          ? Opacity(
                              opacity: group == 0 ? 0.3 : 1,
                              child: RadioListTile(
                                  //tileColor: Colors.green,
                                  activeColor: buttonColor,
                                  selectedTileColor: Colors.red,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  title: Text(
                                    'Select slots',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  value: 1,
                                  groupValue: group,
                                  onChanged: (value) async {
                                    int x = 0;
                                    setState(() {
                                      group = value as int?;
                                    });
                                  }),
                            )
                          : Container(),
                      context.watch<ProductProvider>().instorepickup == false && checkout[0].Deliverydate != null && checkout[0].Deliverydate != ""
                          ? Padding(padding: EdgeInsets.only(bottom: 10), child: Text(checkout[0].nextslotmsg!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )))
                          : Container(),
                      group == 1 && context.watch<ProductProvider>().instorepickup == false
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 3),
                                controller:
                                    ScrollController(keepScrollOffset: false),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: new List<Widget>.generate(
                                    timeslots?.length ?? 0, (index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: timeslots?[index].slotstatus == '0'
                                          ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.grey, Colors.grey],
                                      )
                                          : (timeslots?[index].slotid == context.watch<StoreProvider>().selectedtimeslot?.slotid
                                          ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Color(0xFF158644), Color(0xFF65B84C)],
                                      )
                                          : LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.white, Colors.white],
                                      )),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      border: Border.all(
                                        color: kMainColor,
                                      ),
                                    ),
                                    child: TextButton(
                                      child: Text(
                                        timeslots![index].slotname.toString(),
                                        // AppLocalizations.of(context)!.add!,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: timeslots[index]
                                                            .slotid ==
                                                        context
                                                            .watch<
                                                                StoreProvider>()
                                                            .selectedtimeslot
                                                            ?.slotid
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      // style: TextButton.styleFrom(
                                      //     maximumSize: Size(30, 30)),
                                      onPressed: () {
                                        if (timeslots[index].slotstatus != '0') {
                                          context.read<StoreProvider>()
                                              .selecttimeslot(timeslots[index].slotid);
                                          setState(() {

                                          });
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ),
                            )
                          : Container(),
                      Container(
                        height: context.watch<ProductProvider>().instorepickup == false ? 145.0 : 180.0,
                        color: Theme.of(context).cardColor,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 13.0,
                                bottom: 13.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                InkWell(
                                  onTap: context
                                              .watch<ProductProvider>()
                                              .instorepickup ==
                                          false
                                      ? () async {
                                          editAddress(context);
                                        }
                                      : null,
                                  child: Row(
                                    children: <Widget>[
                                      context
                                                  .watch<ProductProvider>()
                                                  .instorepickup ==
                                              false
                                          ? Icon(
                                              Icons.location_on,
                                              color: Color(0xffc4c8c1),
                                              size: 13.3,
                                            )
                                          : Image.asset(
                                              'images/maincategory/custom_deliveryact.png',
                                              scale: 10),
                                      SizedBox(
                                        width: 11.0,
                                      ),
                                      Text(
                                          context
                                                      .watch<ProductProvider>()
                                                      .instorepickup ==
                                                  false
                                              ? AppLocalizations.of(context)!
                                                  .deliver!
                                              : 'You can pick your order from',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: kDisabledColor,
                                                  fontWeight: FontWeight.bold)),
                                      context
                                                      .watch<Addressprovider>()
                                                      .selectedAddress !=
                                                  null &&
                                              context
                                                      .watch<ProductProvider>()
                                                      .instorepickup ==
                                                  false
                                          ? Text(
                                              context
                                                      .watch<Addressprovider>()
                                                      .selectedAddress!
                                                      .title ??
                                                  '',
                                              /* AppLocalizations.of(context)!.homeText! */
                                              maxLines: 3,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: kMainColor,
                                                      fontWeight:
                                                          FontWeight.bold))
                                          : Container(),
                                      context
                                                  .watch<ProductProvider>()
                                                  .instorepickup ==
                                              false
                                          ? Icon(Icons.arrow_drop_down)
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                context
                                            .watch<ProductProvider>()
                                            .instorepickup ==
                                        true
                                    ? Text(
                                        context
                                                .watch<StoreProvider>()
                                                .selectedstore!
                                                .shopName ??
                                            '',
                                        /* AppLocalizations.of(context)!.homeText! */
                                        maxLines: 3,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: kMainColor,
                                                fontWeight: FontWeight.bold))
                                    : Container(),
                                context
                                            .watch<Addressprovider>()
                                            .selectedAddress !=
                                        null
                                    ? Text(
                                        context
                                                    .watch<ProductProvider>()
                                                    .instorepickup ==
                                                false
                                            ? context
                                                        .watch<
                                                            Addressprovider>()
                                                        .selectedAddress !=
                                                    null
                                                ? (context
                                                            .watch<
                                                                Addressprovider>()
                                                            .selectedAddress!
                                                            .address1 !=
                                                        ''
                                                    ? context
                                                            .watch<
                                                                Addressprovider>()
                                                            .selectedAddress!
                                                            .address1
                                                            .toString() +
                                                        context
                                                            .watch<
                                                                Addressprovider>()
                                                            .selectedAddress!
                                                            .address2!
                                                    : context
                                                        .watch<
                                                            Addressprovider>()
                                                        .selectedAddress!
                                                        .address
                                                        .toString())
                                                : '' /* AppLocalizations.of(context)!.homeText! */ : context.watch<StoreProvider>().selectedstore!.saddress!,
                                        /* '1024, Central Residency Hemilton Park, New York, USA' */
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 11.7, color: Colors.grey))
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        BottomBar(
                            text: 'Checkout', //AppLocalizations.of(context)!.pay! + " \$ 11.50",
                            onTap: () async {

                              if(context.read<ProductProvider>().instorepickup == true) {

                                await context
                                    .read<Addressprovider>()
                                    .getaddresses(isload: true);
                                await context
                                    .read<StoreProvider>()
                                    .getComplimentary();
                                print(
                                    '----------${context.read<Addressprovider>().selectedAddress?.title}');
                                // await context.read<ProductProvider>().getcarttotal();
                                if (context
                                    .read<Addressprovider>()
                                    .selectedAddress ==
                                    null) {
                                  showMessage(
                                      'Please select a delivery address/please ');
                                } else if (context
                                    .read<Addressprovider>()
                                    .selectedAddress
                                    ?.address1 ==
                                    '' ||
                                    context
                                        .read<Addressprovider>()
                                        .selectedAddress
                                        ?.address2 ==
                                        '' ||
                                    context
                                        .read<Addressprovider>()
                                        .selectedAddress
                                        ?.latitude ==
                                        '') {
                                  editAddress(context);
                                  showMessage(
                                      'Please fill your complete address');
                                } else if (double.parse(
                                    checkout[0].posttaxamount!) >=
                                    double.parse(checkout[0]
                                        .minimumbasket!
                                        .toString()) &&
                                    context
                                        .read<Addressprovider>()
                                        .selectedAddress !=
                                        null) {

                                  checkout[0].Deliverydate != null && checkout[0].Deliverydate != ""
                                      ? confirmNextDayDeliveryDialog(timeslots, checkout[0].nextslotmsg!)
                                      : confirmAddressDialog(timeslots);

                                } else {
                                  showMessage(
                                      'Minimum order amount is \u{20B9} ${checkout[0].minimumbasket}');
                                }
                              }
                              else {

                                int t = 0;
                                for (var i in timeslots!) {
                                  print('Closing Time ${i.closetime}');
                                  if (i.slotstatus != '0') {
                                    if (i.slotid == context.read<StoreProvider>().selectedtimeslot?.slotid) {
                                      t++;
                                    }
                                  }
                                }
                                print('Count $t');
                                if (t == 0) {
                                  showMessage('Select a valid time slot');
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    _scrollController.jumpTo(
                                      _scrollController
                                          .position.maxScrollExtent +
                                          500,
                                    );
                                  });
                                } else {
                                  await context
                                      .read<Addressprovider>()
                                      .getaddresses(isload: true);
                                  await context
                                      .read<StoreProvider>()
                                      .getComplimentary();
                                  print(
                                      '----------${context.read<Addressprovider>().selectedAddress?.title}');
                                  // await context.read<ProductProvider>().getcarttotal();
                                  if (context
                                      .read<Addressprovider>()
                                      .selectedAddress ==
                                      null) {
                                    showMessage(
                                        'Please select a delivery address/please ');
                                  } else if (context
                                      .read<Addressprovider>()
                                      .selectedAddress
                                      ?.address1 ==
                                      '' ||
                                      context
                                          .read<Addressprovider>()
                                          .selectedAddress
                                          ?.address2 ==
                                          '' ||
                                      context
                                          .read<Addressprovider>()
                                          .selectedAddress
                                          ?.latitude ==
                                          '') {
                                    editAddress(context);
                                    showMessage(
                                        'Please fill your complete address');
                                  } else if (double.parse(
                                      checkout[0].posttaxamount!) >=
                                      double.parse(checkout[0]
                                          .minimumbasket!
                                          .toString()) &&
                                      context
                                          .read<Addressprovider>()
                                          .selectedAddress !=
                                          null) {

                                    checkout[0].Deliverydate != null && checkout[0].Deliverydate != ""
                                        ? confirmNextDayDeliveryDialog(timeslots, checkout[0].nextslotmsg!)
                                        : confirmAddressDialog(timeslots);

                                  } else {
                                    showMessage(
                                        'Minimum order amount is \u{20B9} ${checkout[0].minimumbasket}');
                                  }
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/icons/shoppingcart.png',
                          height: 200,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Your Cart is empty")
                      ],
                    ),
                  ),
                ),
              ),
        // beginOffset: Offset(0, 0.3),
        // endOffset: Offset(0, 0),
        // slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  Future<dynamic> confirmAddressDialog(timeslots) {
    return showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.98,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF158644), // Dark Green
                                Color(0xFF65B84C),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        height: 40,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Confirm Address",
                                style: TextStyle(color: kWhiteColor),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel_rounded,
                                  color: Colors.red,
                                  size: 25,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.place,
                                            size: 12,
                                            color: Colors.redAccent,
                                          ),
                                          Text(
                                            "Location",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Text("- "),
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.60,
                                          child: Text(
                                            navigatorKey.currentState!.context
                                                .read<Addressprovider>()
                                                .selectedAddress!.address.toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      child: Text(
                                        "Flat/House No.",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    Text("- "),
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.60,
                                          child: Text(
                                            navigatorKey.currentState!.context
                                                .read<Addressprovider>()
                                                .selectedAddress!.address1.toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      child: Text(
                                        "Building/Society Name",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    Text("- "),
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.60,
                                          child: Text(
                                            navigatorKey.currentState!.context
                                                .read<Addressprovider>()
                                                .selectedAddress!.address2
                                                .toString(),
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      editAddress(context);
                                    },
                                    child: Text("Edit Address", style: TextStyle(color: Colors.white))),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () async {
                                      var result = await context
                                          .read<ProductProvider>()
                                          .checkout(
                                              context.read<ProductProvider>().instorepickup == true
                                                  ? '2'
                                                  : group == 0 ? '0' : '1',
                                              group == 1
                                                  ? context.read<StoreProvider>().selectedtimeslot?.slotid ?? ''
                                                  : '',
                                          checkout[0].Deliverydate != null && checkout[0].Deliverydate != "" ? "1" : "");
                                      print("result $result");
                                      if (result == null || result == '') {
                                        Navigator.pop(context);
                                        if (context
                                                    .read<StoreProvider>()
                                                    .complimentary ==
                                                null ||
                                            context
                                                    .read<StoreProvider>()
                                                    .complimentary
                                                    ?.d ==
                                                null ||
                                            context
                                                    .read<StoreProvider>()
                                                    .complimentary
                                                    ?.d[0]
                                                    .skuname ==
                                                null ||
                                            context
                                                    .read<StoreProvider>()
                                                    .complimentary
                                                    ?.d[0]
                                                    .skuname ==
                                                "") {
                                          context
                                              .read<ProductProvider>()
                                              .getcarttotal();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentSelection()));
                                        } else {
                                          complimentaryDialog(context);
                                        }
                                      } else if (result == '1') {
                                        int t = 0;
                                        for (var i in timeslots!) {
                                          if (i.slotstatus != '0') {
                                            t++;
                                          }
                                        }
                                        if (t == 0) {
                                          Navigator.pop(context);
                                          showMessage(
                                              'Sorry, no timeslots available');
                                        } else
                                          Navigator.pop(context);
                                        showMessage('Select a valid time slot');
                                        SchedulerBinding.instance
                                            .addPostFrameCallback((_) {
                                          _scrollController.jumpTo(
                                            _scrollController
                                                    .position.maxScrollExtent +
                                                500,
                                          );
                                        });
                                      } else if (result == '4') {
                                        Navigator.pop(context);
                                        showDialog(
                                            context:
                                                navigatorKey.currentContext!,
                                            builder: (context) => Center(
                                                    child: AlertDialog(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .cardColor,
                                                  content: Material(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            height: 300,
                                                            width: 300,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color: Colors
                                                                    .white),
                                                            child: Image.asset(
                                                                'images/logos/Store-Closed.jpeg'),
                                                          ),
                                                          PositionedDirectional(
                                                            start: 60,
                                                            bottom: 20,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    'Store Timings',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!),
                                                                Text(
                                                                    '${context.read<StoreProvider>().selectedstore?.opentime} to ${context.read<StoreProvider>().selectedstore?.closetime}',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                            backgroundColor:
                                                                    buttonColor),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("ok"))
                                                  ],
                                                )));
                                      }
                                      // _confettiControllerLeft.play();
                                      // _confettiControllerRight.play();
                                      _controllerCenter.play();
                                      Future.delayed(Duration(seconds: 1), () {
                                        _controllerCenter.stop();
                                      });
                                    },
                                    child: Text("Proceed To Pay", style: TextStyle(color: Colors.white),))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  Future<dynamic> confirmNextDayDeliveryDialog(timeslots, msg) {
    return showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       Padding(padding: EdgeInsets.all(10),
                       child:  Text(
                         msg,
                         overflow: TextOverflow.clip,
                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.red),
                       ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel", style:  TextStyle(color: Colors.white))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  confirmAddressDialog(timeslots);
                                },
                                child: Text("Confirm & Proceed", style:  TextStyle(color: Colors.white),))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<dynamic> complimentaryDialog(BuildContext context) {
    var compli = context.read<StoreProvider>().complimentary?.d;
    return showDialog(
        barrierColor: Colors.transparent.withOpacity(0.8),
        context: context,
        builder: (context) => Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: kMainColor.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 3,
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 10, bottom: 20.0),
                                  child: ClipPath(
                                    clipper: ArcClipper(),
                                    child: Container(
                                        width: 200.0,
                                        height: 140.0,
                                        // padding: EdgeInsets.all(5.0),
                                        color: Colors.red,
                                        child: Center(
                                            child: compli?[0].amount == null ||
                                                    compli?[0].amount ==
                                                        "0.00" ||
                                                    compli?[0].amount ==
                                                        "0.0" ||
                                                    compli?[0].amount == "0"
                                                ? Text(
                                                    "Complimentary Item",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14.0),
                                                  )
                                                : Text(
                                                    "Offer Item",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14.0),
                                                  ))),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  child: ClipPath(
                                    clipper: TriangleClipper(),
                                    child: Container(
                                      width: 20.0,
                                      height: 20.0,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel_rounded,
                                  color: Colors.red,
                                  size: 25,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: ConfettiWidget(
                                  confettiController: _controllerCenter,
                                  blastDirectionality:
                                      BlastDirectionality.explosive,
                                  numberOfParticles: 20,
                                  shouldLoop: true,
                                  createParticlePath: drawStar,
                                ),
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: compli?.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Container(
                                      height: 100,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        image: compli?[index].skuimage !=
                                                    null &&
                                                compli?[index].skuimage != ""
                                            ? DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        BaseUrl +
                                                            'skuimages/' +
                                                            compli![index]
                                                                .skuimage
                                                                .toString(),
                                                        cacheKey: compli[index]
                                                            .skuimage
                                                        // fit: BoxFit.cover,
                                                        ),
                                                onError:
                                                    (exception, stackTrace) {
                                                  compli[index].skuimage = "";
                                                },
                                              )
                                            : DecorationImage(
                                                image: AssetImage(
                                                  'images/logos/not-available.png',
                                                ),
                                              ),
                                      ),
                                    ),
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          compli![index].skuname,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 13,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          compli[index].skupacksize,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.purple),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Qty - ${compli[index].itemCount == "" ? 0 : double.parse(compli[index].itemCount).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.purple),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      compli?[0].amount == null ||
                              compli?[0].amount == "0.00" ||
                              compli?[0].amount == "0.0" ||
                              compli?[0].amount == "0"
                          ? Text("")
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                              child: Text(
                                  "Do you want to buy this item at : \₹${double.parse(compli![0].amount).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}",
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontSize: 16)),
                            ),
                      compli?[0].amount == null ||
                              compli?[0].amount == "0.00" ||
                              compli?[0].amount == "0.0" ||
                              compli?[0].amount == "0"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () {
                                      hideLoading();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentSelection()));
                                    },
                                    icon: Icon(Icons.done_rounded, size: 20),
                                    label: Text("ok")),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () async {
                                      context
                                          .read<ProductProvider>()
                                          .getcarttotal();
                                      hideLoading();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentSelection()));
                                    },
                                    icon: Icon(Icons.done_rounded, size: 20, color: Colors.white),
                                    label: Text(
                                        AppLocalizations.of(context)!.yes!, style: TextStyle(color: Colors.white))),
                                SizedBox(width: 50),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () async {
                                      await context
                                          .read<StoreProvider>()
                                          .removeComplimentary();
                                      context
                                          .read<ProductProvider>()
                                          .getcarttotal();
                                      hideLoading();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentSelection()));
                                    },
                                    icon: Icon(Icons.cancel_outlined, size: 20, color: Colors.white,),
                                    label: Text(
                                        AppLocalizations.of(context)!.no!, style: TextStyle(color: Colors.white))),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ));
  }

  Column cartOrderItemListTile(
    BuildContext context,
    String image,
    String title,
    String price,
    int itemCount,
    String itemweight,
    Function onPressedMinus,
    Function onPressedPlus,
    Function onPressedDelete,
    String MRP,
    String totalamount,
    bool isloading,
  ) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: image != ''
              ? CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  backgroundImage: CachedNetworkImageProvider(
                      BaseUrl + 'skuimages/' + image,
                      cacheKey: image), //AssetImage(image),
                  onBackgroundImageError: (exception, stackTrace) {
                    image = '';
                  },
                )
              : CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage('images/logos/not-available.png'),
                ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 12),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                // width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '\u{20B9} $price',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(width: 5),
                    MRP != ''
                        ? Text('\₹ $MRP',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough))
                        : Container(),
                    Spacer(),
                    Text('\₹ $totalamount',
                        style: Theme.of(context).textTheme.bodyMedium!),
                    /*  InkWell(
                      child: Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.indigo,
                      ),
                      onTap: onPressedDelete as void Function()?,
                    ), */
                  ],
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 30.0,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: /* DropdownButtonHideUnderline(
                      child: DropdownButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 16.7,
                          ),
                          iconEnabledColor: Colors.green,
                          value: selected,
                          items: listDrop,
                          hint: Text(
                            '1 kg',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onChanged: (dynamic value) {
                            setState(() {
                              selected = value;
                            });
                          }),
                    ), */
                        Center(
                      child: Text(
                        itemweight,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                    height: 30.0,
                    //width: 76.7,
                    // padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: buttonColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: isloading == true
                        ? CircularProgressIndicator(
                            color: kMainColor,
                          )
                        : Row(
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.all(3),
                                icon: Icon(Icons.remove),
                                color: buttonColor,
                                //size: 20.0,
                                //size: 23.3,
                                onPressed: (itemCount > 0)
                                    ? onPressedMinus as void Function()?
                                    : null,
                              ),
                              Text(itemCount.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium),
                              IconButton(
                                padding: EdgeInsets.all(3),
                                icon: Icon(Icons.add),
                                color: buttonColor,
                                //size: 20.0,
                                onPressed: onPressedPlus as void Function()?,
                              ),
                            ],
                          ),
                  ),
                  //Spacer(),
                  /*  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.indigo,
                    onPressed: onPressedDelete as void Function()?,
                  ), */
                  /*  Text(
                    '\u{20B9} $price',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ), */
                ]),
          ),
        )
      ],
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  final index;
  final catName;
  BottomSheetWidget({this.index, this.catName});
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pincodeController = TextEditingController(
      text: (navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addresses !=
              null)
          ? navigatorKey.currentState!.context
              .read<Addressprovider>()
              .addresses
              ?.d![navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addressindex]
              .pincode
          : '');
  TextEditingController flatNoController = TextEditingController(
      text: (navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addresses !=
              null)
          ? navigatorKey.currentState!.context
              .read<Addressprovider>()
              .addresses
              ?.d![navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addressindex]
              .address1
          : '');
  TextEditingController buildingController = TextEditingController(
      text: (navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addresses !=
              null)
          ? navigatorKey.currentState!.context
              .read<Addressprovider>()
              .addresses
              ?.d![navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addressindex]
              .address2
          : '');
  @override
  Widget build(
    BuildContext context,
  ) {
    final products = context.watch<ProductProvider>().products?.d;
    return FadedSlideAnimation(
      child: Stack(
        children: [
          ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                    height: 500,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: kMainColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Address: ",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 34),
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  child: Text(
                                    navigatorKey.currentState!.context
                                        .read<Addressprovider>()
                                        .addresses!
                                        .d![navigatorKey.currentState!.context
                                            .read<Addressprovider>()
                                            .addressindex]
                                        .address
                                        .toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pin,
                                  color: kMainColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Pincode: ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  navigatorKey.currentState!.context
                                      .read<Addressprovider>()
                                      .addresses!
                                      .d![navigatorKey.currentState!.context
                                          .read<Addressprovider>()
                                          .addressindex]
                                      .pincode
                                      .toString(),
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pin,
                                  color: kMainColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Location: ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  navigatorKey.currentState!.context
                                      .read<Addressprovider>()
                                      .addresses!
                                      .d![navigatorKey.currentState!.context
                                          .read<Addressprovider>()
                                          .addressindex]
                                      .locationName
                                      .toString(),
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            controller: flatNoController,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.startsWith(RegExp(r'[\s]')))
                                return 'Enter your house number';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.house,
                                color: kMainColor,
                              ),
                              labelText: 'Flat No/House No',
                              labelStyle: TextStyle(color: Colors.grey),
                              // border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            controller: buildingController,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.startsWith(RegExp(r'[\s]')))
                                return 'Enter your building name';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.location_city,
                                color: kMainColor,
                              ),
                              labelText: 'Building name/Society Name',
                              labelStyle: TextStyle(color: Colors.grey),
                              //border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
          PositionedDirectional(
            bottom: 0,
            end: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              child: Text("Save Address"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}

editAddress(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pincodeController = TextEditingController(
      text: (navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addresses !=
              null)
          ? navigatorKey.currentState!.context
              .read<Addressprovider>()
              .addresses
              ?.d![navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addressindex]
              .pincode
          : '');
  TextEditingController flatNoController = TextEditingController(
      text: (navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addresses !=
              null)
          ? navigatorKey.currentState!.context
              .read<Addressprovider>()
              .addresses
              ?.d![navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addressindex]
              .address1
          : '');
  TextEditingController buildingController = TextEditingController(
      text: (navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addresses !=
              null)
          ? navigatorKey.currentState!.context
              .read<Addressprovider>()
              .addresses
              ?.d![navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addressindex]
              .address2
          : '');
  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF158644), // Dark Green
                            Color(0xFF65B84C),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Edit Address",
                              style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel_rounded,
                                color: Colors.red,
                                size: 25,
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        controller: flatNoController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              value.startsWith(RegExp(r'[\s]')))
                            return 'Enter your house number';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.house,
                            color: kMainColor,
                          ),
                          labelText: 'Flat No/House No',
                          labelStyle: TextStyle(color: Colors.grey),
                          // border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        controller: buildingController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              value.startsWith(RegExp(r'[\s]')))
                            return 'Enter your building name';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.location_city,
                            color: kMainColor,
                          ),
                          labelText: 'Building name/Society Name',
                          labelStyle: TextStyle(color: Colors.grey),
                          //border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.place,
                                  color: kMainColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Address: ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 34),
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Text(
                                navigatorKey.currentState!.context
                                    .read<Addressprovider>()
                                    .addresses!
                                    .d![navigatorKey.currentState!.context
                                        .read<Addressprovider>()
                                        .addressindex]
                                    .address
                                    .toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        )),
                    Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text("Add New", style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddNewAddress()));
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text("Save Address", style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await context
                                    .read<Addressprovider>()
                                    .updateaddress(
                                        locationId: navigatorKey
                                            .currentState!.context
                                            .read<Addressprovider>()
                                            .addresses!
                                            .d![navigatorKey
                                                .currentState!.context
                                                .read<Addressprovider>()
                                                .addressindex]
                                            .locationId,
                                        addr1: flatNoController.text,
                                        addr2: buildingController.text,
                                        address: navigatorKey
                                            .currentState!.context
                                            .read<Addressprovider>()
                                            .addresses!
                                            .d![navigatorKey
                                                .currentState!.context
                                                .read<Addressprovider>()
                                                .addressindex]
                                            .address,
                                        title: navigatorKey.currentState!.context
                                            .read<Addressprovider>()
                                            .addresses!
                                            .d![navigatorKey
                                                .currentState!.context
                                                .read<Addressprovider>()
                                                .addressindex]
                                            .title,
                                        lat: navigatorKey.currentState!.context
                                            .read<Addressprovider>()
                                            .addresses!
                                            .d![navigatorKey
                                                .currentState!.context
                                                .read<Addressprovider>()
                                                .addressindex]
                                            .latitude,
                                        long: navigatorKey.currentState!.context
                                            .read<Addressprovider>()
                                            .addresses!
                                            .d![navigatorKey
                                                .currentState!.context
                                                .read<Addressprovider>()
                                                .addressindex]
                                            .longitude,
                                        pincode: navigatorKey
                                            .currentState!.context
                                            .read<Addressprovider>()
                                            .addresses!
                                            .d![navigatorKey
                                                .currentState!.context
                                                .read<Addressprovider>()
                                                .addressindex]
                                            .pincode,
                                        Action: "2");
                                navigatorKey.currentState?.context
                                    .read<ProductProvider>()
                                    .getcarttotal();
                                await navigatorKey.currentState?.context
                                    .read<ProductProvider>()
                                    .getcartitems();
                                await navigatorKey.currentState?.context
                                    .read<Addressprovider>()
                                    .getaddresses(isload: true);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        );
      });
}

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({super.key});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pincodeController = TextEditingController(
      text: (navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addresses !=
              null)
          ? navigatorKey.currentState!.context
              .read<Addressprovider>()
              .addresses
              ?.d![navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addressindex]
              .pincode
          : '');
  TextEditingController flatNoController = TextEditingController(
      text: (navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addresses !=
              null)
          ? navigatorKey.currentState!.context
              .read<Addressprovider>()
              .addresses
              ?.d![navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addressindex]
              .address1
          : '');
  TextEditingController buildingController = TextEditingController(
      text: (navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addresses !=
              null)
          ? navigatorKey.currentState!.context
              .read<Addressprovider>()
              .addresses
              ?.d![navigatorKey.currentState!.context
                  .read<Addressprovider>()
                  .addressindex]
              .address2
          : '');
  TextEditingController addrtypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppNavBar(
        titleWidget: Text(
          'Add New Address',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.88,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: flatNoController,
                  validator: (value) {
                    if (value!.isEmpty || value.startsWith(RegExp(r'[\s]')))
                      return 'Enter your house number';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.house,
                      color: kMainColor,
                    ),
                    labelText: 'Flat No/House No',
                    labelStyle: TextStyle(color: Colors.grey),
                    // border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: buildingController,
                  validator: (value) {
                    if (value!.isEmpty || value.startsWith(RegExp(r'[\s]')))
                      return 'Enter your building name';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.location_city,
                      color: kMainColor,
                    ),
                    labelText: 'Building name/Society Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    //border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: kMainColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Address: ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 34),
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Text(
                          navigatorKey.currentState!.context
                              .read<Addressprovider>()
                              .addresses!
                              .d![navigatorKey.currentState!.context
                                  .read<Addressprovider>()
                                  .addressindex]
                              .address
                              .toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.label_outlined,
                      color: kMainColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Save this address as :',
                        style: Theme.of(context).textTheme.bodyMedium!),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 10),
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: addrtypeController,
                  decoration: InputDecoration(
                    hintText: '',
                    icon: Icon(
                      Icons.label_outlined,
                      color: kMainColor,
                    ),
                    labelText:
                        'Address Title eg: home/office', //AppLocalizations.of(context)!.address!,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    //border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.startsWith(RegExp(r'[\s]')))
                      return 'Enter an address label';
                    else
                      return null;
                  },
                ),
              ),
              Spacer(),
              BottomBar(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await context.read<Addressprovider>().addaddress(
                          flatNoController.text,
                          buildingController.text,
                          addrtypeController.text,
                          navigatorKey.currentState!.context
                              .read<Addressprovider>()
                              .addresses!
                              .d![navigatorKey.currentState!.context
                                  .read<Addressprovider>()
                                  .addressindex]
                              .latitude,
                          navigatorKey.currentState!.context
                              .read<Addressprovider>()
                              .addresses!
                              .d![navigatorKey.currentState!.context
                                  .read<Addressprovider>()
                                  .addressindex]
                              .longitude,
                          navigatorKey.currentState!.context
                              .read<Addressprovider>()
                              .addresses!
                              .d![navigatorKey.currentState!.context
                                  .read<Addressprovider>()
                                  .addressindex]
                              .address,
                          navigatorKey.currentState!.context
                              .read<Addressprovider>()
                              .addresses!
                              .d![navigatorKey.currentState!.context
                                  .read<Addressprovider>()
                                  .addressindex]
                              .pincode!,
                          navigatorKey.currentState!.context
                              .read<Addressprovider>()
                              .addresses!
                              .d![navigatorKey.currentState!.context
                                  .read<Addressprovider>()
                                  .addressindex]
                              .locationId, navigatorKey.currentState!.context
                          .read<Addressprovider>()
                          .addresses!
                          .d![navigatorKey.currentState!.context
                          .read<Addressprovider>()
                          .addressindex].CityId);
                      if (context
                              .read<Addressprovider>()
                              .addresses
                              ?.d?[0]
                              .duplicate !=
                          '1') {
                        await navigatorKey.currentState?.context
                            .read<ProductProvider>()
                            .getcarttotal();
                        await navigatorKey.currentState?.context
                            .read<ProductProvider>()
                            .getcartitems();
                        await navigatorKey.currentState?.context
                            .read<Addressprovider>()
                            .getaddresses(isload: true);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        await navigatorKey.currentState?.context
                            .read<Addressprovider>()
                            .getaddresses(isload: false);
                        showMessage(
                            'Addressname already exists.Please save with a different name');
                      }
                    }
                  },
                  text: "Save")
            ]),
          ),
        ),
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(15.0, 0.0);

    var firstControlPoint = Offset(7.5, 2.0);
    var firstPoint = Offset(5.0, 5.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(2.0, 7.5);
    var secondPoint = Offset(0.0, 15.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 20, size.height / 2);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
