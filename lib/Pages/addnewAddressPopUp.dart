import 'dart:math';

import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CommonWidget.dart';
import '../Components/common_app_nav_bar.dart';
import '../Components/entry_field.dart';
import '../Providers.dart/Address_provider.dart';
import '../Providers.dart/ProductProvider.dart';
import '../Providers.dart/login_provider.dart';
import '../Providers.dart/store_provider.dart';
import '../geo/LocationProvider.dart';

class AddNewAddressPopUP extends StatefulWidget {
  const AddNewAddressPopUP({super.key});

  @override
  State<AddNewAddressPopUP> createState() => _AddNewAddressPopUPState();
}

class _AddNewAddressPopUPState extends State<AddNewAddressPopUP> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController flatNoController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController addrtypeController = TextEditingController();
  FocusNode? myFocusNode;

  String pinCode = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CommonAppNavBar(
        titleWidget: Text(
          'Add New Address',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.88,
            child: Column(children: [
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
                          context
                              .watch<LocationServiceProvider>()
                              .address
                              .toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  )),
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
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                child: TextFormField(
                  focusNode: myFocusNode,
                  controller: pincodeController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (value.length == 6) {
                      context
                          .read<Addressprovider>()
                          .addresses
                          ?.d![context.read<Addressprovider>().addressindex]
                          .locationId = "";
                      context
                          .read<Addressprovider>()
                          .addresses
                          ?.d![context.read<Addressprovider>().addressindex]
                          .locationName = "";
                      var response = await context
                          .read<LoginProvider>()
                          .checkAvailablePincode(value);
                      if (response != "0") {
                        if (context.read<LoginProvider>().pincodes!.d != null) {
                          print(context
                              .read<LoginProvider>()
                              .pincodes!
                              .d![0]
                              .locationId);
                          prefs.setString(
                              'LocationId',
                              context
                                  .read<LoginProvider>()
                                  .pincodes!
                                  .d![0]
                                  .locationId
                                  .toString());
                        }
                      } else {
                        pincodeController.text = "";
                        context
                            .read<Addressprovider>()
                            .addresses
                            ?.d![context.read<Addressprovider>().addressindex]
                            .pincode = "";
                        context
                            .read<Addressprovider>()
                            .addresses
                            ?.d![context.read<Addressprovider>().addressindex]
                            .locationName = "";
                        context
                            .read<LoginProvider>()
                            .pincodes!
                            .d![0]
                            .locationName = "";
                        context.read<LoginProvider>().pincodes?.d = [];
                      }
                      FocusScope.of(context).unfocus();
                    }
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                  autofocus: false,
                  enabled: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a post code/pin code";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Postal code / Pin code*',
                    icon: Image.asset(
                      'images/icons/zip-code.png',
                      color: kMainColor,
                      height: 20,
                    ),
                  ),
                ),
              ),
              context
                              .watch<Addressprovider>()
                              .addresses
                              ?.d![
                                  context.watch<Addressprovider>().addressindex]
                              .locationId !=
                          null &&
                      context
                              .watch<Addressprovider>()
                              .addresses
                              ?.d![
                                  context.watch<Addressprovider>().addressindex]
                              .locationId !=
                          ""
                  ? InkWell(
                      onTap: () {
                        print("first one");
                        myFocusNode?.requestFocus();
                        pincodeController.clear();
                      },
                      child: EntryField(
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: buttonColor,
                          size: 30,
                        ),
                        enabled: false,
                        label: context
                            .watch<Addressprovider>()
                            .addresses
                            ?.d![context.watch<Addressprovider>().addressindex]
                            .locationName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                        image: 'images/icons/shop.png',
                        keyboardType: TextInputType.number,
                        readOnly: true,
                      ),
                    )
                  : context.watch<LoginProvider>().pincodes == null
                      ? Container()
                      : context.watch<LoginProvider>().pincodes!.d!.length > 1
                          ? Padding(
                              padding: EdgeInsets.only(left: 40.0),
                              child: DropdownButtonFormField<String>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                isDense: true,
                                value: context
                                    .watch<LoginProvider>()
                                    .pincodes
                                    ?.d![0]
                                    .locationId,
                                alignment: AlignmentDirectional.topStart,
                                hint: Container(
                                    width: 250,
                                    child: Text(
                                      'Select Location',
                                      textAlign: TextAlign.center,
                                    )),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: kMainColor,
                                ),
                                iconSize: 24.0,
                                elevation: 10,
                                onChanged: (String? newValue) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('LocationId', newValue!);
                                  print("new value $newValue");
                                },
                                items: context
                                    .watch<LoginProvider>()
                                    .pincodes
                                    ?.d!
                                    .map<DropdownMenuItem<String>>((item) {
                                  return DropdownMenuItem<String>(
                                    alignment: AlignmentDirectional.centerStart,
                                    value: item.locationId,
                                    child: Text(
                                      item.locationName!,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                print("secondone");
                                myFocusNode?.requestFocus();
                                pincodeController.clear();
                              },
                              child: EntryField(
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                },
                                suffixIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: buttonColor,
                                  size: 30,
                                ),
                                enabled: false,
                                label: context
                                            .watch<LoginProvider>()
                                            .pincodes!
                                            .d?[0]
                                            .locationName !=
                                        null
                                    ? context
                                        .watch<LoginProvider>()
                                        .pincodes!
                                        .d![0]
                                        .locationName
                                    : "Select Pincode",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                                image: 'images/icons/shop.png',
                                keyboardType: TextInputType.number,
                                readOnly: true,
                              ),
                            ),
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
                    // SharedPreferences prefs =
                    //     await SharedPreferences.getInstance();
                    if (_formKey.currentState!.validate()) {
                      await context.read<Addressprovider>().addaddress(
                          flatNoController.text,
                          buildingController.text,
                          addrtypeController.text,
                          navigatorKey.currentState!.context
                              .read<LocationServiceProvider>()
                              .getLatitude(),
                          navigatorKey.currentState!.context
                              .read<LocationServiceProvider>()
                              .getLongitude(),
                          navigatorKey.currentState!.context
                              .read<LocationServiceProvider>()
                              .address,
                          pincodeController.text,
                          navigatorKey.currentState!.context
                              .read<Addressprovider>()
                              .addresses!
                              .d![navigatorKey.currentState!.context
                                  .read<Addressprovider>()
                                  .addressindex]
                              .locationId,
                          navigatorKey.currentState!.context
                              .read<Addressprovider>()
                              .addresses!
                              .d![navigatorKey.currentState!.context
                              .read<Addressprovider>().addressindex].CityId);
                      if (context
                              .read<Addressprovider>()
                              .addresses
                              ?.d?[0]
                              .duplicate !=
                          '1') {
                        await navigatorKey.currentState?.context
                            .read<StoreProvider>()
                            .getstoredetailsbyaddressid(
                                addressid: navigatorKey.currentState?.context
                                    .read<Addressprovider>()
                                    .selectedAddress
                                    ?.addressId,
                                loading: false);
                        var storeid = navigatorKey.currentState?.context
                                    .read<StoreProvider>()
                                    .stores
                                    ?.d
                                    ?.length ==
                                0
                            ? ""
                            : await navigatorKey.currentState?.context
                                .read<StoreProvider>()
                                .selectstore(
                                    "${navigatorKey.currentState?.context.read<StoreProvider>().stores?.d?[0].wareHouseId}");
                        navigatorKey.currentState?.context
                            .read<ProductProvider>()
                            .instorepickup = false;
                        print('hhhh$storeid');

                        if (context
                                .read<ProductProvider>()
                                .cartitems
                                ?.d
                                ?.isNotEmpty ==
                            true) {
                          await context
                              .read<ProductProvider>()
                              .removeallProducts();
                          context.read<StoreProvider>().refresh();
                        }

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
