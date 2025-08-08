import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Globalservices.dart';
import 'package:delivoo/HomeOrderAccount/home_order_account.dart';
import 'package:delivoo/Pages/get_location_on_start.dart';
import 'package:delivoo/geo/LocationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth/MobileNumber/UI/phone_number.dart';
import 'Providers.dart/banner_provider.dart';
import 'Providers.dart/login_provider.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  GlobalService globalService = GlobalService();

  @pragma('vm:entry-point')
  Future<bool> checkGpsEnabled() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("isFirst", "true");

    Location location = new Location();
    bool enabled = await location.serviceEnabled();
    var newLocation = 'false';
    if (!enabled) {
      await getData();
    } else if (enabled) {
      Location().getLocation().then((position) async {
        newLocation = await 'true';
        await prefs.setString('locationisON', 'true');
      });
    }
    newLocation == 'true'
        ? await prefs.setString('locationisON', 'true')
        : await prefs.setString('locationisON', 'false');
    await getData();
    return true;
  }

  getData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = await context.read<LoginProvider>().getMapFlag();

    hideLoading();

    print(result);

    if (result != null) {

      prefs.setString('mapFlag', result);
      var comid = prefs.getString('com_id');
      var mobile = prefs.getString('mob_no');
      print("haslaunched ${globalService.hasLaunched}");
      if (!globalService.hasLaunched) {
        if (comid != null && mobile != null) {
          print("comid" + comid + '-------' + mobile);
          Timer(Duration(seconds: 2),
                  () async {
                print("location check ${prefs.getString('locationisON')}");
                if (await prefs.getString('locationisON') == "true") {
                  await Location().getLocation().then((position) async {
                    await prefs.setString('locationisON', 'true');
                    await context
                        .read<LocationServiceProvider>()
                        .getAddressFromLatLng(
                        context: context,
                        lat: position.latitude,
                        lng: position.longitude);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyCurrentLocation(flag: false)),
                            (route) => false);
                  }).catchError((e) async {
                    print("errrooorrrrrr " + e.toString());
                    print('locationService disabled1');
                    await prefs.setString('locationisON', 'false');
                  });
                } else {
                  await prefs.setString('locationisON', 'false');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeOrderAccount()),
                          (route) => false);
                }
              });
        }
        else {
          Timer(Duration(seconds: 2),
                  () async {
                print("location check ${prefs.getString('locationisON')}");
                if (await prefs.getString('locationisON') == "true") {
                  await Location().getLocation().then((position) async {
                    await prefs.setString('locationisON', 'true');
                    await context
                        .read<LocationServiceProvider>()
                        .getAddressFromLatLng(
                        context: context,
                        lat: position.latitude,
                        lng: position.longitude);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => PhoneNumber()));
                  }).catchError((e) async {
                    print("errrooorrrrrr " + e.toString());
                    print('locationService disabled1');
                    await prefs.setString('locationisON', 'false');
                  });
                } else {
                  await prefs.setString('locationisON', 'false');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PhoneNumber()));
                }
              });
        }
      }
    } else {

      prefs.setString('mapFlag', "MapMyIndia");
      var comid = prefs.getString('com_id');
      var mobile = prefs.getString('mob_no');
      print("haslaunched ${globalService.hasLaunched}");
      if (!globalService.hasLaunched) {
        if (comid != null && mobile != null) {
          print("comid" + comid + '-------' + mobile);
          Timer(Duration(seconds: 2),
                  () async {
                print("location check ${prefs.getString('locationisON')}");
                if (await prefs.getString('locationisON') == "true") {
                  await Location().getLocation().then((position) async {
                    await prefs.setString('locationisON', 'true');
                    await context
                        .read<LocationServiceProvider>()
                        .getAddressFromLatLng(
                        context: context,
                        lat: position.latitude,
                        lng: position.longitude);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyCurrentLocation(flag: false)),
                            (route) => false);
                  }).catchError((e) async {
                    print("errrooorrrrrr " + e.toString());
                    print('locationService disabled1');
                    await prefs.setString('locationisON', 'false');
                  });
                } else {
                  await prefs.setString('locationisON', 'false');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeOrderAccount()),
                          (route) => false);
                }
              });
        }
        else {
          Timer(Duration(seconds: 2),
                  () async {
                print("location check ${prefs.getString('locationisON')}");
                if (await prefs.getString('locationisON') == "true") {
                  await Location().getLocation().then((position) async {
                    await prefs.setString('locationisON', 'true');
                    await context
                        .read<LocationServiceProvider>()
                        .getAddressFromLatLng(
                        context: context,
                        lat: position.latitude,
                        lng: position.longitude);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => PhoneNumber()));
                  }).catchError((e) async {
                    print("errrooorrrrrr " + e.toString());
                    print('locationService disabled1');
                    await prefs.setString('locationisON', 'false');
                  });
                } else {
                  await prefs.setString('locationisON', 'false');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PhoneNumber()));
                }
              });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () async {
      await checkGpsEnabled();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            AvatarGlow(
              glowColor: Colors.green[300]!,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              child: Image.asset(
                'images/logos/ketransparent.png',
                height: 150,
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 140,
                  child: Image.asset(
                    'images/logos/Kisanserv.png',
                    height: 150,
                    scale: 0.1,
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 30,
                  // start: MediaQuery.of(context).size.height * 0.50,
                  child: Text('a product of',
                      style: TextStyle(
                        color: Colors.black,
                          fontSize: 14,
                      )),
                ),
              ],
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
