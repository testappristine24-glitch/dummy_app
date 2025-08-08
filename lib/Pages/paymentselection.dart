import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Pages/Webview.dart';
import 'package:delivoo/Providers.dart/Payment_provider.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/main.dart';
import 'package:flutter/material.dart';
// import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppConstants.dart';
import '../CommonWidget.dart';
import '../Components/common_app_nav_bar.dart';
import '../payU_money/hashservice.dart';
import '../payU_money/payu_money.dart';
import 'order_success_page.dart';

class PaymentSelection extends StatefulWidget {
  @override
  _PaymentSelectionState createState() => _PaymentSelectionState();
}

class _PaymentSelectionState extends State<PaymentSelection> {
    // implements PayUCheckoutProProtocol {
  var _razorpay = Razorpay();
  // late PayUCheckoutProFlutter _checkoutPro;
  var failedId = "";
  @override
  void initState() {
    print("failedid" + failedId);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // _checkoutPro = PayUCheckoutProFlutter(this);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Success: " + response.paymentId.toString());
    print("Payment orderid: " + response.orderId.toString());
    print("Payment signature: " + response.signature.toString());
    var res = await context
        .read<Paymentprovider>()
        .getrazorpayreply(response.paymentId);
    if (res == "Success") {
      context.read<ProductProvider>().instorepickup = false;
      context.read<ProductProvider>().removeallProducts();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => OrderPlacedSuccessfully()),
          (route) => false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print("Payment Error: " +
        response.code.toString() +
        " - " +
        response.message.toString());

    Future.delayed(Duration(seconds: 1), () async {
      var res = await context.read<Paymentprovider>().razorpayAuth();
      print("res " + res);
      failedId = await res;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: " + response.walletName.toString());
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  int? group;
  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<ProductProvider>().cartTotal?.d;
    final cartitems = context.watch<ProductProvider>().cartitems?.d;

    return Scaffold(
        appBar: CommonAppNavBar(
          titleWidget: Text('Payment Selection',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white)),
        ),
        body: Stack(children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
            child: ListView(
                //mainAxisAlignment: MainAxisAlignment.start,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Center(
                      child: Text(
                          AppLocalizations.of(context)!
                              .paymentInfo!
                              .toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: kDisabledColor)),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.checklist, color: kMainColor),
                          SizedBox(width: 5),
                          Text(
                            AppLocalizations.of(context)!.sub!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Spacer(),
                          cartitems != null && cartitems.isNotEmpty
                              ? Text(
                                  '\u{20B9} ${checkout?[0].subtotal}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              : Text(
                                  '\u{20B9} 0',
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                          Icon(Icons.delivery_dining, color: Colors.brown),
                          SizedBox(width: 5),
                          Text(
                            'Delivery charges',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Spacer(),
                          cartitems != null && cartitems.isNotEmpty
                              ? Text(
                                  '\u{20B9} ${checkout?[0].delcharge}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              : Text(
                                  '\u{20B9} 0',
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                          Icon(Icons.savings_outlined, color: Colors.pink[200]),
                          SizedBox(width: 5),
                          Text(
                            'Savings',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Spacer(),
                          cartitems != null && cartitems.isNotEmpty
                              ? Text(
                                  '\u{20B9} ${checkout?[0].savingamount}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              : Text(
                                  '\u{20B9} 0',
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                          Icon(Icons.account_balance_wallet_outlined,
                              color: Colors.green),
                          SizedBox(width: 5),
                          Text(
                            'Wallet',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Icon(Icons.check_box, color: Colors.green),
                          Spacer(),
                          cartitems != null &&
                                  cartitems.isNotEmpty &&
                                  checkout?[0].walletamt != ''
                              ? Text(
                                  '\u{20B9} ${checkout?[0].walletamt}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              : Text(
                                  '\u{20B9} 0',
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                          Icon(Icons.discount, color: Colors.red),
                          SizedBox(width: 5),
                          Text(
                            'Coupon',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Spacer(),
                          cartitems != null && cartitems.isNotEmpty
                              ? Text(
                                  '\u{20B9} ${checkout?[0].couponamt}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              : Text(
                                  '\u{20B9} 0',
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                            AppLocalizations.of(context)!.amount!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          (double.parse(checkout![0].posttaxamount!) -
                                      double.parse(checkout[0].couponamt!)) >
                                  double.parse(checkout[0].walletamt.toString())
                              ? Text(
                                  cartitems != null && cartitems.isNotEmpty
                                      ? '\u{20B9} ${double.parse(checkout[0].posttaxamount!) - (double.parse(checkout[0].walletamt.toString()) + double.parse(checkout[0].couponamt.toString()))}'
                                      : '\u{20B9} 0',
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  cartitems != null && cartitems.isNotEmpty
                                      ? '\u{20B9} ${double.parse(checkout[0].posttaxamount!) - double.parse(checkout[0].couponamt!)}'
                                      : '\u{20B9} 0',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                        ]),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Using Wallet amount : \u{20B9} ',
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                        Text(
                          (double.parse(checkout[0].posttaxamount!) -
                                      double.parse(checkout[0].couponamt!)) >=
                                  double.parse(checkout[0].walletamt.toString())
                              ? checkout[0].walletamt == ''
                                  ? '0'
                                  : checkout[0].walletamt.toString()
                              : (double.parse(checkout[0].posttaxamount!) -
                                      double.parse(checkout[0].couponamt!))
                                  .toString(),
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1.0,
                  ),
                  (double.parse(checkout[0].posttaxamount!) -
                              double.parse(checkout[0].couponamt!)) >
                          double.parse(checkout[0].walletamt.toString())
                      ? ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Select a payment option to proceed',
                                style: TextStyle(
                                    fontSize: 20, letterSpacing: 0.005),
                              ),
                            ),
                            SizedBox(height: 20),
                            RadioListTile(
                                activeColor: buttonColor,
                                tileColor: Theme.of(context).cardColor,
                                selectedTileColor: Colors.red,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: /* Image.asset('images/logos/Razorpay_logo.png',
                          scale: 20, alignment: Alignment.centerLeft), */
                                    Text(
                                  'Debit Card/Credit Card/ATM Card',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Image.asset('images/logos/all.png',
                                    scale: 1,
                                    alignment: Alignment.centerLeft,
                                    height: 70),
                                value: 1,
                                groupValue: group,
                                onChanged: (value) {
                                  setState(() {
                                    group = value as int?;
                                  });
                                }),
                            Divider(
                              color: Theme.of(context).cardColor,
                              thickness: 1.0,
                            ),
                            RadioListTile(
                                tileColor: Theme.of(context).cardColor,
                                selectedTileColor: Colors.red,
                                activeColor: buttonColor,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Image.asset('images/logos/upi.png',
                                    scale: 1,
                                    alignment: Alignment.centerLeft,
                                    height: 40),
                                value: 2,
                                groupValue: group,
                                onChanged: (value) {
                                  setState(() {
                                    group = value as int?;
                                  });
                                }),
                            Divider(
                              color: Theme.of(context).cardColor,
                              thickness: 1.0,
                            ),
                            RadioListTile(
                                activeColor: buttonColor,
                                tileColor: Theme.of(context).cardColor,
                                selectedTileColor: Colors.red,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Image.asset('images/logos/pluxee.png',
                                    scale: 1,
                                    alignment: Alignment.centerLeft,
                                    height: 30),
                                value: 3,
                                groupValue: group,
                                onChanged: (value) async {
                                  setState(() {
                                    group = value as int?;
                                  });
                                  // await context.read<StoreProvider>().gettimeslots();
                                }),
                          ],
                        )
                      : Container(),
                  SizedBox(height: 100)
                ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: BottomBar(
                  onTap: () async {
                    print('-------${checkout[0].posttaxamount}');

                    if ((double.parse(checkout[0].posttaxamount!) -
                            double.parse(checkout[0].couponamt!)) >
                        double.parse(checkout[0].walletamt.toString())) {
                      if (group == 1) {
                        if (failedId ==
                            'payment_failed') {
                          var res = await context
                              .read<Paymentprovider>()
                              .checkrazorpayAuth();
                          if (res == 'Success') {
                            failedId = "";
                            context
                                .read<ProductProvider>()
                                .instorepickup = false;
                            await context
                                .read<ProductProvider>()
                                .removeallProducts();
                            Navigator.of(navigatorKey
                                .currentState!
                                .context)
                                .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        OrderPlacedSuccessfully()),
                                    (route) => false);
                          } else {
                            razorpayCardPaymnet(
                                checkout);
                          }
                        } else {
                          razorpayCardPaymnet(checkout);
                        }

                      } else if (group == 2) {
                        if (failedId ==
                            'payment_failed') {
                          var res = await context
                              .read<Paymentprovider>()
                              .checkrazorpayAuth();
                          if (res == 'Success') {
                            failedId = "";
                            context
                                .read<ProductProvider>()
                                .instorepickup = false;
                            await context
                                .read<ProductProvider>()
                                .removeallProducts();
                            Navigator.of(navigatorKey
                                .currentState!
                                .context)
                                .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        OrderPlacedSuccessfully()),
                                    (route) => false);
                          } else {
                            razorPayUPIPayment(
                                checkout);
                          }
                        } else {
                          razorPayUPIPayment(checkout);
                        }
                      } else if (group == 3) {
                        double.parse(checkout[0].walletamt.toString()) != 0.00
                            ? print('1')
                            : print('0');
                        await context.read<Paymentprovider>().sodexopayment(
                            double.parse(checkout[0].walletamt.toString()) !=
                                    0.00
                                ? '1'
                                : '0');
                        print('sodexo');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => WebViewScreen()));
                      } else {
                        showMessage('Please select a payment option.');
                      }
                    } else {
                      await context.read<Paymentprovider>().paybywallet();
                      await context.read<ProductProvider>().removeallProducts();

                      //  Future.delayed(Duration(seconds: 3), () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (c) => OrderPlacedSuccessfully()),
                          (route) => false);
                    }
                  },
                  text: 'Pay now'))
        ]));
  }

  razorpayCardPaymnet(checkout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await context.read<Paymentprovider>().getrazorpayId(
        double.parse(checkout[0].walletamt.toString()) != 0 ? '1' : '0');
    var options = {
      //'key': rzrpy_TEST,
      'key': rzrpy,
      'amount': (double.parse(
              '${double.parse(checkout[0].posttaxamount!) - (double.parse(checkout[0].walletamt.toString()) + double.parse(checkout[0].couponamt.toString()))}')) *
          100,

      // (double.parse('${checkout[0].posttaxamount}') *
      //     100),
      //in the format of paise: eg. "500" = Rs 5.00
      'name': 'KisanServ',
      'order_id':
          context.read<Paymentprovider>().razorpayId, //'order_9A33XWu170gUtm',
      //Generate order_id using Orders API
      'description':
          'Payment for order ${context.read<Paymentprovider>().razorpaytxnId}',
      'timeout': 300,
      // time in seconds to timeout
      'prefill': {
        'contact': prefs.getString('mob_no'),
        'email': prefs.getString('email'),
      },
      "notify": {"sms": false, "email": false},
      "method": {
        "netbanking": true,
        "card": true,
        "upi": false,
        "wallet": false,
        "emi": false,
        "paylater": false
      }
    };
    context.read<Paymentprovider>().razorpayId != null &&
            context.read<Paymentprovider>().razorpayId != ""
        ? _razorpay.open(
            options,
          )
        : showMessage(
            "Issue with bank Payment Gateway.\n Please try using other payment option available.");
  }

  razorPayUPIPayment(checkout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await context.read<Paymentprovider>().getrazorpayId(
        double.parse(checkout[0].walletamt.toString()) != 0 ? '1' : '0');
    var options = {
      //'key': rzrpy_TEST,
      'key': rzrpy,
      'amount': (double.parse(
              '${double.parse(checkout[0].posttaxamount!) - (double.parse(checkout[0].walletamt.toString()) + double.parse(checkout[0].couponamt.toString()))}')) *
          100,
      // double.parse('${checkout[0].posttaxamount}') * 100,
      //in the format of paise: eg. "500" = Rs 5.00
      'name': 'KisanServ',
      'order_id':
          context.read<Paymentprovider>().razorpayId, // 'order_9A33XWu170gUtm',
      //Generate order_id using Orders API
      'description':
          'Payment for order ${context.read<Paymentprovider>().razorpaytxnId}',
      'timeout': 300,
      // time in seconds to timeout
      'prefill': {
        'contact': prefs.getString('mob_no'),
        'email': prefs.getString('email'),
      },
      "notify": {"sms": false, "email": false},
      "method": {
        "netbanking": false,
        "card": false,
        "upi": true,
        "wallet": false,
        "emi": false,
        "paylater": false
      }
    };
    context.read<Paymentprovider>().razorpayId != null &&
            context.read<Paymentprovider>().razorpayId != ""
        ? _razorpay.open(
            options,
          )
        : showMessage(
            "Issue with bank Payment Gateway.\n Please try using other payment option available.");
  }

  @override
  generateHash(Map response) {
    Map hashResponse = {};
    // hashResponse = HashService.generateHash(response);
    // _checkoutPro.hashGenerated(hash: hashResponse);
  }

  @override
  onError(Map? response) {
    print(response.toString());
    // showAlertDialog(context, "onError", response.toString());
  }

  @override
  onPaymentCancel(Map? response) async {
    showMessage("Payment Cancel");
    await context.read<Paymentprovider>().getPayUreplyCancel(
        context.read<Paymentprovider>().payUDetails!.d.udf5, "cancelled");
  }

  @override
  onPaymentFailure(response) async {
    print(response.toString());
    showMessage("Payment failed");
    await context.read<Paymentprovider>().getPayUreplyCancel(
        context.read<Paymentprovider>().payUDetails!.d.udf5, "Failed by Payu");
  }

  @override
  onPaymentSuccess(response) async {
    print("responseeeeeeeeeeeeeeeeeeeeeeee${response}");
    await context
        .read<Paymentprovider>()
        .getPayUreply(context.read<Paymentprovider>().payUDetails!.d.udf5);
    context.read<ProductProvider>().instorepickup = false;
    context.read<ProductProvider>().removeallProducts();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => OrderPlacedSuccessfully()),
        (route) => false);
  }
}
