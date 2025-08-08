// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Providers.dart/Address_provider.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/geo/LocationProvider.dart';
import 'package:delivoo/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Components/common_app_nav_bar.dart';
import '../../../../Components/entry_field.dart';
import '../../../../Models/CityListModel.dart';
import '../../../../Providers.dart/login_provider.dart';

class UpdateAddressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: CommonAppNavBar(
          titleWidget: Text(
            context.read<Addressprovider>().addrediting == false
                ? 'Add New Address'
                : 'Edit address', //AppLocalizations.of(context)!.saved!,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            await context.read<Addressprovider>().getaddresses(isload: true);
            return Future.value(true);
          },
          child: FadedSlideAnimation(
            child: UpdateAddresses(),
            beginOffset: Offset(0, 0.3),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        ));
  }
}

class UpdateAddresses extends StatefulWidget {
  @override
  _UpdateAddressesState createState() => _UpdateAddressesState();
}

String? _address1;
String? lat = navigatorKey.currentState!.context
    .watch<LocationServiceProvider>()
    .getLatitude()
    .toString();
String? long = navigatorKey.currentState!.context
    .watch<LocationServiceProvider>()
    .getLongitude()
    .toString();

class _UpdateAddressesState extends State<UpdateAddresses> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedValue;
  String? selectedCityId = "";

  Completer<MapplsMapController> _controller = Completer();
  TextEditingController flatNoController = TextEditingController(
      text: (navigatorKey.currentState!.context
          .read<Addressprovider>()
          .addrediting ==
          true)
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
          .addrediting ==
          true)
          ? navigatorKey.currentState!.context
          .read<Addressprovider>()
          .addresses
          ?.d![navigatorKey.currentState!.context
          .read<Addressprovider>()
          .addressindex]
          .address2
          : '');

  TextEditingController addrtypeController = TextEditingController(
      text: (navigatorKey.currentState!.context
          .read<Addressprovider>()
          .addrediting ==
          true)
          ? navigatorKey.currentState!.context
          .read<Addressprovider>()
          .addresses
          ?.d![navigatorKey.currentState!.context
          .read<Addressprovider>()
          .addressindex]
          .title
          : '');
  TextEditingController pincodeController = TextEditingController(
      text: (navigatorKey.currentState!.context
          .read<Addressprovider>()
          .addrediting ==
          true)
          ? navigatorKey.currentState!.context
          .read<Addressprovider>()
          .addresses
          ?.d![navigatorKey.currentState!.context
          .read<Addressprovider>()
          .addressindex]
          .pincode
          : '');
  String? place;
  FocusNode? myFocusNode;
  @override
  void initState() {
    if (navigatorKey.currentState!.context.read<Addressprovider>().addrediting == false) {
      clearLocationIdfromSharedPreference();
    } else {
      addStoreLocation();
    }
    myFocusNode = FocusNode();
    getCityList();
    super.initState();
  }

  void getCityList() {
    context
        .read<LoginProvider>()
        .getCityList();
  }

  clearLocationIdfromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('LocationId', "");
    context.read<LoginProvider>().pincodes?.d = [];
  }

  addStoreLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'LocationId',
        navigatorKey.currentState!.context.read<Addressprovider>().addresses != null
            ? navigatorKey.currentState!.context.read<Addressprovider>().addresses!.d![navigatorKey.currentState!.context.read<Addressprovider>().addressindex].locationId.toString()
            : "");
  }

  String pinCode = "";

  @override
  Widget build(BuildContext context) {

    var cityList = context.watch<LoginProvider>().cityListModel;

    TextEditingController addrController = TextEditingController(
        text: (context.read<Addressprovider>().addrediting == false)
            ? context.read<LocationServiceProvider>().address!.toString()
            : '');

    pincodeController.text = context
        .watch<LocationServiceProvider>()
        .userAddressPinCode
        .toString();

    return Stack(
      children: [
        ListView(
            physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            shrinkWrap: false,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: kMainColor,
                              ),
                              Spacer(),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  context
                                      .watch<LocationServiceProvider>()
                                      .address
                                      .toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 180),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kMainColor,
                              border: Border.all(color: kMainColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            //color: Colors.indigo,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  splashColor: Colors.amber,
                                  child: Text('change location',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold)),
                                  onTap: () async {
                                    Navigator.pop(context);
                                  }),
                            ),
                          ),
                        ),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 8.0),
                          child: TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            focusNode: myFocusNode,
                            controller: pincodeController,
                            onChanged: (value) async {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              if (value.length == 6) {
                                context
                                    .read<Addressprovider>()
                                    .addresses
                                    ?.d![context
                                    .read<Addressprovider>()
                                    .addressindex]
                                    .locationId = "";
                                context
                                    .read<Addressprovider>()
                                    .addresses
                                    ?.d![context
                                    .read<Addressprovider>()
                                    .addressindex]
                                    .locationName = "";
                                var response = await context
                                    .read<LoginProvider>()
                                    .checkAvailablePincode(value);
                                if (response != "0") {
                                  if (context
                                      .read<LoginProvider>()
                                      .pincodes!
                                      .d !=
                                      null) {
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
                                }
                                else {
                                  pincodeController.text = "";
                                  context
                                      .read<Addressprovider>()
                                      .addresses
                                      ?.d![context
                                      .read<Addressprovider>()
                                      .addressindex]
                                      .pincode = "";
                                  context
                                      .read<Addressprovider>()
                                      .addresses
                                      ?.d![context
                                      .read<Addressprovider>()
                                      .addressindex]
                                      .locationName = "";
                                  context
                                      .read<LoginProvider>()
                                      .pincodes!
                                      .d![0]
                                      .locationName = "";
                                  context.read<LoginProvider>().pincodes?.d =
                                  [];
                                }
                                FocusScope.of(context).unfocus();
                              }
                            },
                            style: Theme.of(context).textTheme.bodyMedium,
                            autofocus: false,
                            enabled: false,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter a post code/pin code";
                              }
                              // context
                              //     .read<Addressprovider>()
                              //     .addresses
                              //     ?.d![context.read<Addressprovider>().addressindex]
                              //     .pincode = value;
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

                        cityList == null
                            ? SizedBox.shrink()
                            : Padding(padding: EdgeInsets.only(left: 30, right: 10),
                          child: Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select City',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: cityList.cityData!.map((CityData item) => DropdownMenuItem<String>(
                                  value: item.CityName,
                                  child: Text(
                                    item.CityName!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )).toList(),
                                value: selectedValue,
                                onChanged: (String? value) async {
                                  setState(() {
                                    for (int i = 0; i < cityList.cityData!.length; i++) {
                                      if(cityList.cityData?[i].CityName == value) {
                                        selectedCityId = cityList.cityData?[i].CityId;
                                      }
                                    }
                                    selectedValue = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 0, right: 14),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white,
                                  ),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all<double>(6),
                                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 10, right: 14),
                                ),
                              ),
                            ),
                          ),),
                        Divider(
                          color: Theme.of(context).cardColor,
                          thickness: 1.0,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: context
                                        .read<Addressprovider>()
                                        .addresstype ==
                                        'Home'
                                        ? kMainColor
                                        : Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                                height:
                                MediaQuery.of(context).size.height * 0.05,
                                child: TextButton(
                                  child: Text(
                                    'Home',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color: context
                                            .watch<
                                            Addressprovider>()
                                            .addresstype ==
                                            'Home'
                                            ? Colors.white
                                            : kMainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //style: TextButton.styleFrom(),
                                  onPressed: context
                                      .watch<Addressprovider>()
                                      .addrediting ==
                                      false ||
                                      context
                                          .watch<Addressprovider>()
                                          .addresstype ==
                                          'Home'
                                      ? () {
                                    context
                                        .read<Addressprovider>()
                                        .addresstype = 'Home';
                                    context
                                        .read<Addressprovider>()
                                        .changecolor();
                                  }
                                      : () {
                                    showMessage(
                                        "Can't Change Address Type");
                                  },
                                )),
                            Container(
                                decoration: BoxDecoration(
                                    color: context
                                        .watch<Addressprovider>()
                                        .addresstype ==
                                        'Work'
                                        ? kMainColor
                                        : Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                                height:
                                MediaQuery.of(context).size.height * 0.05,
                                child: TextButton(
                                  child: Text(
                                    'Work',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color: context
                                            .watch<
                                            Addressprovider>()
                                            .addresstype ==
                                            'Work'
                                            ? Colors.white
                                            : kMainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //style: TextButton.styleFrom(),
                                  onPressed: context
                                      .watch<Addressprovider>()
                                      .addrediting ==
                                      false ||
                                      context
                                          .watch<Addressprovider>()
                                          .addresstype ==
                                          'Work'
                                      ? () {
                                    context
                                        .read<Addressprovider>()
                                        .addresstype = 'Work';
                                    context
                                        .read<Addressprovider>()
                                        .changecolor();
                                  }
                                      : () {
                                    showMessage(
                                        "Can't Change Address Type");
                                  },
                                )),
                            Container(
                                decoration: BoxDecoration(
                                    color: (context
                                        .watch<Addressprovider>()
                                        .addresstype !=
                                        'Home' &&
                                        context
                                            .watch<Addressprovider>()
                                            .addresstype !=
                                            'Work'
                                        ? kMainColor
                                        : Colors.white),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                                height:
                                MediaQuery.of(context).size.height * 0.05,
                                child: TextButton(
                                  child: Text(
                                    'Other',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color: context
                                            .watch<
                                            Addressprovider>()
                                            .addresstype !=
                                            'Home' &&
                                            context
                                                .watch<
                                                Addressprovider>()
                                                .addresstype !=
                                                'Work'
                                            ? Colors.white
                                            : kMainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //style: TextButton.styleFrom(),
                                  onPressed: context
                                      .watch<Addressprovider>()
                                      .addrediting ==
                                      false ||
                                      context
                                          .watch<Addressprovider>()
                                          .addresstype ==
                                          'Other'
                                      ? () {
                                    context
                                        .read<Addressprovider>()
                                        .addresstype = 'Other';
                                    context
                                        .read<Addressprovider>()
                                        .changecolor();
                                  }
                                      : () {
                                    showMessage(
                                        "Can't Change Address Type");
                                  },
                                )),
                          ],
                        ),
                        context.watch<Addressprovider>().addresstype !=
                            'Home' &&
                            context.watch<Addressprovider>().addresstype !=
                                'Work'
                            ? Padding(
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
                              'Save this address as ', //AppLocalizations.of(context)!.address!,
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              //border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.startsWith(RegExp(r'[\s]')))
                                return 'Enter an address label';
                              else
                                return null;
                            },
                          ),
                        )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        context.watch<Addressprovider>().addnewAdd == true
                            ? Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("(OR)"),
                              ),
                              TextButton(
                                child: Text(
                                  'Add new Address', //AppLocalizations.of(context)!.continueText!,
                                  style:
                                  Theme.of(context).textTheme.bodyLarge,
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8.0),
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: () async {
                                  context
                                      .read<Addressprovider>()
                                      .addrediting = await false;
                                  context
                                      .read<Addressprovider>()
                                      .addnewAdd = await false;
                                  context
                                      .read<Addressprovider>()
                                      .addresstype = 'Other';
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateAddressesPage()));
                                },
                              ),
                            ],
                          ),
                        )
                            : SizedBox.shrink(),
                        context.watch<Addressprovider>().addnewAdd == true
                            ? SizedBox(
                          height: 100,
                        )
                            : SizedBox.shrink()
                      ],
                    )),
              ),
            ]),
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          child: BottomBar(
            color: kMainColor,
            onTap: () async {
              FocusScope.of(context).unfocus();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (_formKey.currentState!.validate()) {

                if(selectedCityId != "") {
                  var clearcart =
                  await context.read<StoreProvider>().checkshoplocation();
                  if (clearcart == '1' &&
                      context.read<ProductProvider>().cartitems?.d?.length !=
                          0) {
                    print('-----------clear cart');
                    context.read<ProductProvider>().removeallProducts();
                    print('----cart cleared');
                  }
                  print('address: $_address1');
                  if (context.read<Addressprovider>().addrediting == true) {

                    await context.read<Addressprovider>().updateaddress(
                        addr1: flatNoController.text,
                        addr2: buildingController.text,
                        address: context
                            .read<LocationServiceProvider>()
                            .address,
                        title: context.read<Addressprovider>().addresstype !=
                            'Home' &&
                            context.read<Addressprovider>().addresstype !=
                                'Work'
                            ? addrtypeController.text
                            : context.read<Addressprovider>().addresstype,
                        lat: context
                            .read<LocationServiceProvider>()
                            .locationResult
                            ?.latLng?.latitude ??
                            '',
                        long: context
                            .read<LocationServiceProvider>()
                            .locationResult
                            ?.latLng?.longitude ??
                            '',
                        pincode: pincodeController.text,
                        Action: "2", cityId: selectedCityId);
                    if (context
                        .read<Addressprovider>()
                        .addresses
                        ?.d?[0]
                        .duplicate !=
                        '1') {
                      await prefs.setString("warehouseid", "");
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

                      if (prefs.getString('orderid') != '' &&
                          prefs.getString('orderid') != null) {
                        navigatorKey.currentState?.context
                            .read<ProductProvider>()
                            .getcarttotal();
                        await navigatorKey.currentState?.context
                            .read<ProductProvider>()
                            .getcartitems();
                        await context
                            .read<Addressprovider>()
                            .getaddresses(isload: true);
                      }
                    }
                  }
                  else {
                    print(addrtypeController.text);
                    print("shared location " +
                        prefs.getString('LocationId').toString());
                    print(
                        "location id ${context.read<Addressprovider>().addresses?.d![context.read<Addressprovider>().addressindex].locationId.toString()}");
                    await context.read<Addressprovider>().addaddress(
                        flatNoController.text,
                        buildingController.text,
                        context.read<Addressprovider>().addresstype == 'Other'
                            ? addrtypeController.text
                            : context
                            .read<Addressprovider>()
                            .addresstype
                            .toString(),
                        context
                            .read<LocationServiceProvider>()
                            .locationResult
                            ?.latLng?.latitude ??
                            '',
                        context
                            .read<LocationServiceProvider>()
                            .locationResult
                            ?.latLng?.longitude ??
                            '',
                        context
                            .read<LocationServiceProvider>()
                            .address,
                        pincodeController.text,
                        "", selectedCityId);
                  }
                  if (context.read<Addressprovider>().addresses?.d?[0].duplicate != '1') {
                    await prefs.setString("warehouseid", "");
                    await navigatorKey.currentState?.context.read<StoreProvider>().getstoredetailsbyaddressid(
                        addressid: navigatorKey.currentState?.context
                            .read<Addressprovider>()
                            .selectedAddress
                            ?.addressId,
                        loading: false);
                    var storeid = navigatorKey.currentState?.context.read<StoreProvider>()
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
                    await context
                        .read<Addressprovider>()
                        .getaddresses(isload: true);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                  else {
                    showMessage(
                        'Addressname already exists.Please save with a different name');
                  }
                } else {
                  showMessage("Select City");
                }
              } else {
                print('invalid');
              }
            },
            text: context.watch<Addressprovider>().addrediting == false
                ? 'Save'
                : 'Continue',
          ),
        ),
      ],
    );
  }

  Future<void> moveCamera() async {
    final MapplsMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        context.read<LocationServiceProvider>().getLocationData?.latitude !=
            null
            ? context.read<LocationServiceProvider>().getLocationData?.latitude
            : context.read<LocationServiceProvider>().locationData!.latitude,
        context.read<LocationServiceProvider>().getLocationData?.longitude !=
            null
            ? context.read<LocationServiceProvider>().getLocationData?.longitude
            : context.read<LocationServiceProvider>().locationData!.longitude,
      ),
      zoom: 14,
    )));
  }
}