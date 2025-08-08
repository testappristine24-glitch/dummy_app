// ignore_for_file: deprecated_member_use, unused_local_variable

library commonwidgets;

// import 'dart:math';

import 'dart:io';
import 'dart:math';

import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:delivoo/Splashscreen.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/geo/GoogleLocationProvider.dart';
import 'package:delivoo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppConstants.dart';
import 'HomeOrderAccount/Account/UI/ListItems/updateaddresses.dart';
import 'HomeOrderAccount/home_order_account.dart';
import 'Providers.dart/Address_provider.dart';
import 'Providers.dart/ProductProvider.dart';
import 'Providers.dart/store_provider.dart';
import 'geo/LocationProvider.dart';
import 'geo/map_screen.dart';

bool isLoader = false;

void showLoading() {
  print('---------showload ${isLoader}');
  // if (!isLoader) {
  //   isLoader = true;
  //   showDialog(
  //       context: navigatorKey.currentState!.context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return Center(
  //             child: Container(
  //               height: 40,
  //               width: 40,
  //               padding: EdgeInsets.all(8),
  //               decoration:
  //               BoxDecoration(shape: BoxShape.circle, color: Colors.white),
  //               child: CircularProgressIndicator(
  //                 strokeWidth: 2,
  //                 color: kMainColor,
  //               ),
  //             ));
  //       });
  // }

  EasyLoading.instance.userInteractions = false;
  EasyLoading.instance.maskType = EasyLoadingMaskType.clear;
  if (EasyLoading.isShow) {
    EasyLoading.show();
  } else {
    EasyLoading.show();
  }
}

void hideLoading() {
  // print('----hideload');
  // isLoader = false;
  // Navigator.pop(navigatorKey.currentState!.context);
  if (EasyLoading.isShow) {
    EasyLoading.dismiss();
  }
}

void showMessage(String message) {
  showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Center(
              child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Theme.of(context).cardColor,
            content: Material(
              color: Theme.of(context).cardColor,
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok",
                      style: TextStyle(
                      color: Colors.white, // Change 'red' to your desired color
                    ),)),
              )
            ],
          )));
}

void noInternet() {
  showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Center(
              child: AlertDialog(
            content: Material(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/logos/nosignal.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Ooops!"),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "No Internet Connection",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text("check your connection", style: TextStyle(fontSize: 14)),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor, fixedSize: Size.fromWidth(100)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("ok"))
                ],
              ),
            ),
          )));
}

void banner() {
  showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) => Center(
              child: AlertDialog(
            content: Material(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.cancel,
                            size: 50,
                            color: kMainColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  Image.asset(
                    'images/logos/no-signal.png',
                  ),
                ],
              ),
            ),
          )));
}

popbanner(img, controllerLeft, controllerRight) {
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

  return showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Material(
          color: Colors.white.withOpacity(0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      BaseUrl + "banners/" + img,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    PositionedDirectional(
                        top: 20,
                        end: 15,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.cancel,
                              size: 40,
                              color: Colors.black,
                            ))),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ConfettiWidget(
                        confettiController: controllerLeft,
                        blastDirectionality: BlastDirectionality.directional,
                        blastDirection: -pi / 3,
                        emissionFrequency: 0.01,
                        numberOfParticles: 20,
                        // maximumSize: const Size(20, 10),
                        // maxBlastForce: 40,
                        // minBlastForce: 30,
                        gravity: 0.1,
                        shouldLoop: true,
                        createParticlePath: drawStar,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ConfettiWidget(
                        confettiController: controllerRight,
                        blastDirectionality: BlastDirectionality.directional,
                        blastDirection: -3 * pi / 4,
                        emissionFrequency: 0.01,
                        numberOfParticles: 20,
                        particleDrag: 0.05,
                        // maximumSize: const Size(20, 10),
                        // maxBlastForce: 40,
                        // minBlastForce: 30,
                        gravity: 0.1,
                        shouldLoop: true,
                        createParticlePath: drawStar,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

showMessageDialog(context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => new AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        message,
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
        ),
      ],
    ),
  );
}

showalert(context, String message) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(message),
        );
      });
}

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(seconds: 3),
      content: Text(content)));
}

checkVersion(context) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final newVersion = NewVersionPlus(
    iOSId: 'com.kisanserv.express', androidId: 'com.kisanserv.alphaexpress', androidPlayStoreCountry: "es_IN", androidHtmlReleaseNotes: true, //support country code
  );

  final ver = VersionStatus(
    appStoreLink: '',
    localVersion: '',
    storeVersion: '',
    releaseNotes: '',
    originalStoreVersion: '',
  );
  print(ver);
  const simpleBehavior = true;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final status = await newVersion.getVersionStatus();
  if (status != null) {
    if (status.localVersion.toString() != status.storeVersion.toString()) {
      await updateApp();
    }
  }
}

Future<dynamic> updateApp() {
  return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("New Update Available!!!", style: TextStyle(color: Colors.black, fontSize: 15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Updated version of the App is available. Please download", style: TextStyle(color: Colors.black))
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                child: Text("Update", style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(color: kWhiteColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green)),
                ),
                onPressed: () async {
                  if (Platform.isAndroid || Platform.isIOS) {
                    final appId = Platform.isAndroid
                        ? "com.kisanserv.alphaexpress"
                        : "com.kisanserv.express";
                    final url = Uri.parse(
                      Platform.isAndroid
                          ? "https://play.google.com/store/apps/details?id=$appId"
                          : "https://apps.apple.com/app/id$appId",
                    );
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    ).whenComplete(() => Navigator.pop(context));
                  }
                }),
            SizedBox(width: 5),
            ElevatedButton(
                child: Text("Maybe Later", style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  textStyle: TextStyle(color: kWhiteColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.redAccent)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ],
        );
      });
}
askLocationPermisson() async {
  if (await Permission.location.serviceStatus.isEnabled) {
    print("permisson is enabled");
  } else {
    print('permission is disabled');
    locationPermisson();
  }

  var status = await Permission.location.status;
  print("statussss ${status}");
  if (status.isGranted) {
    print("location permission is granted");
  } else if (status.isDenied) {
    print("locaiton permission is denied");
    locationPermisson();
  } else if (status.isPermanentlyDenied) {
    locationPermisson();
  }
}

Future<dynamic> LocationChangeAlert(newAddress, isLoad) async {
  await navigatorKey.currentState!.context
      .read<Addressprovider>()
      .getaddresses(isload: false);

  return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.98,
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // color: Colors.blueGrey,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        // height: 80,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width:
                                    MediaQuery.of(context).size.width *
                                        0.80,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        BlinkAnimation(
                                            text:
                                            "You are in a New Location!!!",
                                            size: 20),
                                      ],
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0),
                              child: SizedBox(
                                width:
                                MediaQuery.of(context).size.width * 70,
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.location_on),
                                  label: Text(
                                    "Use my current location",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius:
                                    //         BorderRadius.circular(10)),
                                    backgroundColor: buttonColor,
                                  ),
                                  onPressed: () async {
                                    context
                                        .read<Addressprovider>()
                                        .addrediting = false;
                                    context
                                        .read<Addressprovider>()
                                        .addnewAdd = false;
                                    context
                                        .read<Addressprovider>()
                                        .addresstype = 'Other';

                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    if(prefs.getString("mapFlag") == "Google") {

                                      context
                                          .read<LocationServiceProvider>()
                                          .showPlacePicker(context)
                                          .then((value) {

                                        context
                                            .read<LocationServiceProvider>()
                                            .address = value.toString();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateAddressesPage())).then((value) async {
                                          context
                                              .read<Addressprovider>()
                                              .setLocationDialog(false);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeOrderAccount()),
                                                  (route) => false);
                                        });

                                      });

                                    } else {

                                      showLoading();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));

                                    }
                                    context
                                        .read<Addressprovider>()
                                        .changecolor();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Divider(
                  //   thickness: 5,
                  //   color: Colors.grey,
                  // ),
                  Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width * 90,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "SAVED ADDRESSES",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: AddressWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));

}

//Referral Dialog
refferalDialog(context) {
  InkWell(
    onTap: () {
      showDialog(
          context: context,
          builder: (context) {
            var _formkey = GlobalKey<FormState>();
            TextEditingController orderController = TextEditingController();
            return AlertDialog(
              title: Text(
                "Do have Referral Code? If Yes Please Enter",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _formkey,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value!.length < 1 ? 'Enter Referral Code' : null,
                      textAlign: TextAlign.center,
                      controller: orderController,
                      decoration: InputDecoration(
                        hintText: 'Enter Referral Code',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1)),
                        border: new OutlineInputBorder(
                          borderSide: const BorderSide(width: 2.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        contentPadding: EdgeInsets.only(),
                      ),
                    ),
                  ),
                  Container(
                    child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kMainColor)),
                        onPressed: () async {
                          print(orderController.text);

                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.done),
                        label: Text("ok")),
                  ),
                ],
              ),
            );
          });
    },
    child: Container(
      //height: MediaQuery.of(context).size.height * 0.051,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: kMainColor,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Text("Search by Order No",
              style: TextStyle(
                color: Colors.white,
              )),
          Spacer(),
          Icon(
            Icons.search,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}

locationPermisson() async {
  showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Allow Location Service"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '"Enable Device and App Location" to get nearby Kisanserv Stores.')
            ],
          ),
          actions: <Widget>[
            // ElevatedButton(
            //     child: Text("Cancel"),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.redAccent,
            //       textStyle: TextStyle(color: kWhiteColor),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           side: BorderSide(color: Colors.redAccent)),
            //     ),
            //     onPressed: () async {
            //       Navigator.pop(context);
            //     }),
            // SizedBox(width: 5),

            Center(
              child: ElevatedButton(
                  child: Text(
                    "Enable Location",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.70, 50),
                    backgroundColor: buttonColor,
                    textStyle: TextStyle(color: kWhiteColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: buttonColor)),
                  ),
                  onPressed: () async {
                    AppSettings.openAppSettings(type: AppSettingsType.location)
                        .then((value) => value)
                        .whenComplete(() => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Splashscreen()),
                            (route) => false));
                  }),
            )
          ],
        );
      });
}

class BlinkAnimation extends StatefulWidget {
  final String? text;
  final double? size;
  BlinkAnimation({this.text, this.size});
  @override
  _BlinkAnimationState createState() => _BlinkAnimationState();
}

class _BlinkAnimationState extends State<BlinkAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    animation =
        ColorTween(begin: Colors.blueGrey, end: Colors.red).animate(curve);
    // Keep the animation going forever once it is started
    animation.addStatusListener((status) {
      // Reverse the animation after it has been completed
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });
    // Remove this line if you want to start the animation later
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Text(widget.text!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: animation.value,
                fontSize: widget.size != null
                    ? widget.size
                    : Theme.of(context).textTheme.bodyMedium!.fontSize));
      },
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AddressWidget extends StatefulWidget {
  final index;
  AddressWidget({this.index});
  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  void initState() {
    context.read<Addressprovider>().getaddresses(isload: true);

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    //String? group = 'Home';
    final addresses = context.watch<Addressprovider>().addresses?.d;
    var address = context.watch<Addressprovider>().selectedAddress?.addressId;
    final cartitems = context.watch<ProductProvider>().cartitems?.d;
    final stores = context.watch<StoreProvider>().stores?.d;
    return FadedSlideAnimation(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: addresses?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: addresses![index].adstatus == '1'
                                  ? Color(0xFF65B84C)
                                  : Colors.transparent,
                              boxShadow: addresses[index].adstatus == '1'
                                  ? [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]
                                  : null,
                              border: Border.all(
                                color: addresses[index].adstatus == '1'
                                    ? Colors.grey
                                    : Colors.transparent,
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (addresses[index].addressId !=
                                        prefs.getString("addid") &&
                                    cartitems?.isNotEmpty == true) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => new AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: Text(
                                        "Your cart will be cleared on changing the address",
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () async {
                                            context
                                                .read<ProductProvider>()
                                                .removeallProducts();
                                            var addressid = await context
                                                .read<Addressprovider>()
                                                .getaddressid(addresses[index]
                                                    .addressId!
                                                    .toString());
                                            print(
                                                'ooooooooooo${prefs.getString("addid")}');
                                            print(
                                                'ooo$addresses[index].addressId!---------$addressid');
                                            setState(() {
                                              address = addresses[index]
                                                  .addressId!
                                                  .toString();
                                            });
                                            // Navigator.pop(context);
                                            if (context
                                                        .read<Addressprovider>()
                                                        .selectedAddress
                                                        ?.latitude ==
                                                    '' ||
                                                context
                                                        .read<Addressprovider>()
                                                        .selectedAddress
                                                        ?.latitude ==
                                                    null) {
                                              await context
                                                  .read<
                                                      LocationServiceProvider>()
                                                  .getLocationAccess();

                                              await context
                                                  .read<Addressprovider>()
                                                  .updatelocation(
                                                    context
                                                        .read<Addressprovider>()
                                                        .selectedAddress
                                                        ?.address1,
                                                    context
                                                        .read<Addressprovider>()
                                                        .selectedAddress
                                                        ?.address2,
                                                    context
                                                        .read<Addressprovider>()
                                                        .selectedAddress
                                                        ?.address,
                                                    context
                                                        .read<Addressprovider>()
                                                        .selectedAddress
                                                        ?.title,
                                                    context
                                                        .read<
                                                            LocationServiceProvider>()
                                                        .getLatitude(),
                                                    context
                                                        .read<
                                                            LocationServiceProvider>()
                                                        .getLongitude(),
                                                    context
                                                        .read<Addressprovider>()
                                                        .selectedAddress
                                                        ?.pincode,
                                                    context
                                                        .read<Addressprovider>()
                                                        .selectedAddress
                                                        ?.addressId,
                                                    context
                                                        .read<Addressprovider>()
                                                        .selectedAddress
                                                        ?.locationId,
                                                  context
                                                      .read<Addressprovider>()
                                                      .selectedAddress?.CityId,
                                                  );
                                              context
                                                  .read<Addressprovider>()
                                                  .addrediting = true;

                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              if(prefs.getString("mapFlag") == "Google") {

                                                await context
                                                    .read<
                                                    LocationServiceProvider>()
                                                    .showPlacePicker(context)
                                                    .then((value) async {
                                                  print(value.toString());
                                                  context
                                                      .read<
                                                      LocationServiceProvider>()
                                                      .address = value.toString();

                                                  context
                                                      .read<Addressprovider>()
                                                      .updatelocation(
                                                      context
                                                          .read<
                                                          Addressprovider>()
                                                          .selectedAddress
                                                          ?.address1,
                                                      context
                                                          .read<
                                                          Addressprovider>()
                                                          .selectedAddress
                                                          ?.address2,
                                                      context
                                                          .read<
                                                          Addressprovider>()
                                                          .selectedAddress
                                                          ?.address,
                                                      context
                                                          .read<
                                                          Addressprovider>()
                                                          .selectedAddress
                                                          ?.title,
                                                      context
                                                          .read<
                                                          LocationServiceProvider>()
                                                          .getLatitude(),
                                                      context
                                                          .read<
                                                          LocationServiceProvider>()
                                                          .getLongitude(),
                                                      context
                                                          .read<
                                                          Addressprovider>()
                                                          .selectedAddress
                                                          ?.pincode,
                                                      context
                                                          .read<
                                                          Addressprovider>()
                                                          .selectedAddress
                                                          ?.addressId,
                                                      context
                                                          .read<
                                                          Addressprovider>()
                                                          .selectedAddress
                                                          ?.locationId,
                                                      context
                                                          .read<Addressprovider>()
                                                          .selectedAddress?.CityId
                                                  );

                                                  print(context
                                                      .read<
                                                      LocationServiceProvider>()
                                                      .locationResult
                                                      ?.latLng?.latitude);
                                                });

                                              } else {

                                                showLoading();
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));

                                              }
                                            }
                                            prefs.getString("warehouseid") !=
                                                    null
                                                ? await context
                                                    .read<StoreProvider>()
                                                    .getThestore(
                                                      isLoad: false,
                                                    )
                                                : await context
                                                    .read<StoreProvider>()
                                                    .getstoredetailsbyaddressid(
                                                        addressid: addressid,
                                                        loading: false);
                                            print('no stores');
                                            Navigator.pop(context);
                                            print('hhhhhhhhhh$addressid');

                                            //  if (stores?.length != 0) {

                                            String storeid = await context
                                                .read<StoreProvider>()
                                                .selectstore(
                                                    stores![0].wareHouseId!);

                                            //  }
                                            context
                                                .read<Addressprovider>()
                                                .setLocationDialog(false);
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeOrderAccount()),
                                                (route) => false);
                                          },
                                          child: Text("Clear cart" , style: TextStyle(color: Colors.white)),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            print(
                                                'address id: ${prefs.getString("addid")}');
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel" , style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  var addressid = await context
                                      .read<Addressprovider>()
                                      .getaddressid(addresses[index]
                                          .addressId!
                                          .toString());
                                  print(
                                      'wwwwwwwwwwww$addresses[index].addressId!');
                                  print(addressid);
                                  setState(() {
                                    address =
                                        addresses[index].addressId!.toString();
                                  });
                                  if (context
                                          .read<Addressprovider>()
                                          .selectedAddress
                                          ?.latitude ==
                                      '') {
                                    await context
                                        .read<LocationServiceProvider>()
                                        .getLocationAccess();
                                    await context
                                        .read<Addressprovider>()
                                        .updatelocation(
                                          context
                                              .read<Addressprovider>()
                                              .selectedAddress
                                              ?.address1,
                                          context
                                              .read<Addressprovider>()
                                              .selectedAddress
                                              ?.address2,
                                          context
                                              .read<Addressprovider>()
                                              .selectedAddress
                                              ?.address,
                                          context
                                              .read<Addressprovider>()
                                              .selectedAddress
                                              ?.title,
                                          context
                                              .read<LocationServiceProvider>()
                                              .getLatitude(),
                                          context
                                              .read<LocationServiceProvider>()
                                              .getLongitude(),
                                          context
                                              .read<Addressprovider>()
                                              .selectedAddress
                                              ?.pincode,
                                          context
                                              .read<Addressprovider>()
                                              .selectedAddress
                                              ?.addressId,
                                          context
                                              .read<Addressprovider>()
                                              .selectedAddress
                                              ?.locationId,
                                        context
                                            .read<Addressprovider>()
                                            .selectedAddress?.CityId
                                        );

                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    if(prefs.getString("mapFlag") == "Google") {

                                      await context
                                          .read<LocationServiceProvider>()
                                          .showPlacePicker(context)
                                          .then((value) {
                                        print(value.toString());
                                        context
                                            .read<Addressprovider>()
                                            .updatelocation(
                                            context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.address1,
                                            context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.address2,
                                            context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.address,
                                            context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.title,
                                            context
                                                .read<LocationServiceProvider>()
                                                .getLatitude(),
                                            context
                                                .read<LocationServiceProvider>()
                                                .getLongitude(),
                                            context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.pincode,
                                            context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.addressId,
                                            context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.locationId,
                                            context
                                                .read<Addressprovider>()
                                                .selectedAddress?.CityId
                                        );

                                        print(context
                                            .read<LocationServiceProvider>()
                                            .locationResult
                                            ?.latLng?.latitude);
                                      });

                                    } else {

                                      showLoading();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));

                                    }
                                  }

                                  await context
                                      .read<StoreProvider>()
                                      .getstoredetailsbyaddressid(
                                          addressid: prefs.getString("addid"),
                                          loading: false);
                                  print('-----s-----${stores?.length}');
                                  // if (stores?.length == 1) {
                                  var storeid = await stores?.length == 0
                                      ? ""
                                      : await context
                                          .read<StoreProvider>()
                                          .selectstore(
                                              "${stores?[0].wareHouseId}");
                                  context
                                      .read<Addressprovider>()
                                      .setLocationDialog(false);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeOrderAccount()),
                                      (route) => false);
                                  //  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        addresses[index].title == "Home"
                                            ? Icon(
                                                Icons.home,
                                                size: 15,
                                              )
                                            : SizedBox.shrink(),
                                        Text(addresses[index].title!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500, color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 2.0),
                                          child: Icon(
                                            Icons.location_on,
                                            size: 15,
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  addresses[index].address !=
                                                          null
                                                      ? addresses[index]
                                                          .address!
                                                      : "",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 2.0),
                                          child: Image.asset(
                                            'images/account/home.png',
                                            height: 15.3,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  addresses[index].address1 !=
                                                              '' &&
                                                          addresses[index]
                                                                  .address2 !=
                                                              ''
                                                      ? addresses[index]
                                                              .address1! +
                                                          ', ' +
                                                          addresses[index]
                                                              .address2!
                                                      : addresses[index]
                                                          .address!,
                                                  style:
                                                      TextStyle(fontSize: 10, color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 5,
                          )
                        ],
                      ));
                },
              ),
            ),
          ),
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}
