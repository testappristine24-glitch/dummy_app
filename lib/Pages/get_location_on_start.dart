import 'dart:async';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:delivoo/HomeOrderAccount/home_order_account.dart';
import 'package:delivoo/geo/LocationProvider.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:provider/provider.dart';

import '../Providers.dart/Address_provider.dart';
import '../main.dart';

class MyCurrentLocation extends StatefulWidget {

  var flag;

  MyCurrentLocation({super.key, required this.flag});

  @override
  State<MyCurrentLocation> createState() => _MyCurrentLocationState();
}

class _MyCurrentLocationState extends State<MyCurrentLocation> with SingleTickerProviderStateMixin {

  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    Timer(Duration(seconds: 1), () async {
      await context.read<Addressprovider>().getaddresses(isload: false);

      if(widget.flag) {
        await Location().getLocation().then((position) async {
          print("MAHESH 1 gettting location");
          var res = await context
              .read<LocationServiceProvider>()
              .getAddressFromLatLng(
              context: context,
              lat: position.latitude,
              lng: position.longitude);
          print("locationRes ${res}");
          if (res != "failed") {
            await navigatorKey.currentState?.context
                .read<LocationServiceProvider>()
                .checkStoreFromLatLng(
                context: context,
                lat: position.latitude,
                lng: position.longitude,
                load: false);

            if (await context
                .read<LocationServiceProvider>()
                .storeStatus == "1") {
              if (position.latitude == null ||
                  position.longitude == null ||
                  position.latitude == "" ||
                  position.longitude == "") {
                return "";
              } else {
                await context.read<Addressprovider>().updateNewLocation(
                    addr1: "",
                    addr2: "",
                    address: context
                        .read<LocationServiceProvider>()
                        .getAddress,
                    title: "",
                    lat: position.latitude,
                    long: position.longitude,
                    pincode: context
                        .read<LocationServiceProvider>()
                        .userAddressPinCode,
                    addId: context
                        .read<Addressprovider>()
                        .selectedAddress
                        ?.addressId,
                    Action: "7"
                );
              }
            }
          }
        });
      } else {

        await Location().getLocation().then((position) async {
          await context.read<LocationServiceProvider>().checkStoreFromLatLng(
              context: context,
              lat: position.latitude,
              lng: position.longitude,
              load: false);
        });
      }
      print("i'm here 12");

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeOrderAccount()),
          (route) => false);
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadedSlideAnimation(
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/logos/map_image.png',
                  ),
                  fit: BoxFit.fill,
                  opacity: 0.2),
            ),
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  lottie.Lottie.asset(
                    "images/logos/location_pin.json",
                    repeat: false,
                    controller: _animationController,
                    onLoaded: (composition) {
                      _animationController?.forward();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  context.watch<LocationServiceProvider>().getAddress != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            context
                                        .watch<LocationServiceProvider>()
                                        .getAddress !=
                                    null
                                ? context
                                    .watch<LocationServiceProvider>()
                                    .getAddress
                                    .toString()
                                : "",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        )
                ],
              ),
            )),
      ),
    );
  }
}
