import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../HomeOrderAccount/home_order_account.dart';
import '../Providers.dart/Payment_provider.dart';
import '../Providers.dart/store_provider.dart';

class OrderPlacedSuccessfully extends StatelessWidget {
  const OrderPlacedSuccessfully({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DateTime? currentBackPressTime;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 5)),
                  margin: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.done,
                    size: 45,
                    color: Colors.green,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Order Placed Sucessfully!!",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(
              height: 10,
            ),
            context.watch<Paymentprovider>().orderId != null
                ? Text(
                    "Order #${context.watch<Paymentprovider>().orderId ?? ""}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  )
                : Text(
                    "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
            Spacer(),
            InkWell(
              onTap: () async {
                context.read<StoreProvider>().onTapped(2);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => HomeOrderAccount()),
                    (route) => false);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "VIEW DETAILS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () async {
                context.read<StoreProvider>().onTapped(0);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => HomeOrderAccount()),
                    (route) => false);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                decoration: BoxDecoration(
                  color: kMainColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "GO HOME",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
