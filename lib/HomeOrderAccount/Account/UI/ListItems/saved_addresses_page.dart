import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/updateaddresses.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/Address_provider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/geo/LocationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Components/common_app_nav_bar.dart';
import '../../../../Components/common_home_nav_bar.dart';
import '../../../../geo/map_screen.dart';

class Address {
  final String icon;
  final String? addressType;
  final String address;

  Address(this.icon, this.addressType, this.address);
}

class SavedAddressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CommonAppNavBar(
          titleWidget: Text(
            AppLocalizations.of(context)!.saved!,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        body: FadedSlideAnimation(
          child: SavedAddresses(),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ));
  }
}

class SavedAddresses extends StatefulWidget {
  @override
  _SavedAddressesState createState() => _SavedAddressesState();
}

class _SavedAddressesState extends State<SavedAddresses> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addresses = context.watch<Addressprovider>().addresses;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: addresses?.d?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
                        color: addresses!.d![index].adstatus == '1'
                            ? Colors.grey
                            : Theme.of(context).scaffoldBackgroundColor,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      addresses.d![index].title!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 2.0),
                                          child: Icon(Icons.location_on, size: 15, color: Colors.red),
                                        ),
                                        Expanded(
                                          child: Text(
                                            addresses.d![index].address != null
                                                ? addresses.d![index].address!
                                                : "",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 2.0),
                                          child: Image.asset(
                                            'images/account/home.png',
                                            height: 15.3,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            addresses.d![index].address1 != '' &&
                                                addresses.d![index].address2 != ''
                                                ? addresses.d![index].address1! +
                                                ', ' +
                                                addresses.d![index].address2!
                                                : addresses.d![index].address!,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Wrap(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      if (addresses.d!.length > 1) {
                                        context.read<Addressprovider>().removeaddress(index);
                                      } else {
                                        showMessage("You must have at least one address");
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: kMainColor,
                                    ),
                                    onPressed: () async {
                                      context.read<Addressprovider>().addressindex = index;
                                      context.read<Addressprovider>().addresstype =
                                          addresses.d![index].title;
                                      context.read<Addressprovider>().addrediting = true;

                                      print("CLICKED HERE");

                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      if(prefs.getString("mapFlag") == "Google") {

                                        print("${addresses.d![index].latitude}");
                                        print("CLICKED HERE");

                                        addresses.d![index].latitude == ''
                                            ? context
                                            .read<LocationServiceProvider>()
                                            .showPlacePicker(context)
                                            .then((value) {
                                          print('value: $value');
                                          context
                                              .read<LocationServiceProvider>()
                                              .address = value.toString();
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             UpdateAddressesPage()));
                                        })
                                            : context
                                            .read<LocationServiceProvider>()
                                            .showPlacePickerwithstoredloc(
                                            context,
                                            addresses.d![index].latitude,
                                            addresses.d![index].longitude,
                                            addresses.d![index].address,
                                            addresses.d![index].pincode)
                                            .then((value) {
                                          print('value: $value');
                                          context
                                              .read<LocationServiceProvider>()
                                              .address = value.toString();
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             UpdateAddressesPage()));
                                        });

                                      } else {

                                        showLoading();

                                        // addresses.d![index].latitude == ''
                                        //     ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()))
                                        //     : editFlow(context.read<Addressprovider>().addresses?.d![index].address, context.read<Addressprovider>().addresses?.d![index].pincode);
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));

                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                })),
        BottomBar(
          color: Theme.of(context).scaffoldBackgroundColor,
          text: '+ ' + AppLocalizations.of(context)!.addNew!,
          textColor: Colors.white,
          onTap: () async {
            context.read<Addressprovider>().addrediting = false;
            context.read<Addressprovider>().addresstype = 'Other';

            SharedPreferences prefs = await SharedPreferences.getInstance();
            if(prefs.getString("mapFlag") == "Google") {

              context
                  .read<LocationServiceProvider>()
                  .showPlacePicker(context)
                  .then((value) {
                print('value: $value');

                context.read<LocationServiceProvider>().address =
                    value.toString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateAddressesPage()));
              });

            } else {

              showLoading();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));

            }
            context.read<Addressprovider>().changecolor();
          },
        ),
      ],
    );
  }

  editFlow(String? address, String? pincode) {

    context.read<LocationServiceProvider>().address = address;
    context.read<LocationServiceProvider>().userAddressPinCode = pincode;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                UpdateAddressesPage()));
  }
}
