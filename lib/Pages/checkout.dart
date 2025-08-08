// ignore_for_file: camel_case_types, unused_local_variable, unused_field

import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/saved_addresses_page.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/Address_provider.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class checkoutPage extends StatefulWidget {
  @override
  State<checkoutPage> createState() => _checkoutPageState();
}

class _checkoutPageState extends State<checkoutPage> {
  var _razorpay = Razorpay();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    final checkout = context.watch<ProductProvider>().cartTotal?.d;
    String? value = appLocalization.homeText;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // shrinkWrap: true,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Choose a delivery address : ',
                      //style: TextStyle(letterSpacing: 0.05),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 15),
                    ),
                  ),
                  Consumer<Addressprovider>(builder: (context, model, _) {
                    return Container(
                      height: 25,
                      decoration: BoxDecoration(
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.grey,
                            blurRadius: 20.0,
                          ),
                        ],
                        color: kMainColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(left: 10),
                      //color: Colors.grey,
                      child: DropdownButton(
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: kMainColor,
                        value: context
                                .watch<Addressprovider>()
                                .selectedAddress!
                                .title ??
                            'hi', //value,
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.white //kMainColor,
                            ),
                        iconSize: 24.0,
                        elevation: 16,
                        style: inputTextStyle.copyWith(
                            fontSize: 15, color: Colors.white),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          context
                              .read<Addressprovider>()
                              .getaddressid(newValue!);
                          // print(addressid);
                          /* context.read<StoreProvider>().getstoredetailsbyaddressid('1');
                       */
                          // Navigator.pushNamed(context, PageRoutes.locationPage);
                        },
                        items: model.addresses?.d!
                            .map<DropdownMenuItem<String>>((address) {
                          return DropdownMenuItem<String>(
                            value: address.title,
                            child: Text(
                              address.title!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Delivery address : ${context.watch<Addressprovider>().selectedAddress?.address.toString()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              /* TextButton(
                  // style: TextButton.styleFrom(
                  //     backgroundColor: Colors.amber, maximumSize: Size(70, 50)),
                  onPressed: () {
                    Navigator.pushNamed(context, PageRoutes.locationPage);
                  },
                  child: Container(
                      width: 70,
                      color: Colors.amber,
                      child: Text('Add/Change address'))), */
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 20.0,
                      ),
                    ],
                    color: kMainColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //color: Colors.yellow,
                  height: 40,
                  //width: 50,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SavedAddressesPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Add/Change address',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment Details:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                '20',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SubTotal : ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                "\u{20B9} ${checkout?[0].posttaxamount ?? '0'}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery fee :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                '0',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black26,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'To Pay : ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                "\u{20B9} ${checkout![0].posttaxamount ?? '0'}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black26,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Savings : ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                "\u{20B9} ${checkout[0].savingamount ?? '0'}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            child: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
              },
              child: Container(
                height: 50,
                color: kMainColor,
                child: Center(
                  child: Text(
                    'Proceed to Pay : \u{20B9}${checkout[0].posttaxamount}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
