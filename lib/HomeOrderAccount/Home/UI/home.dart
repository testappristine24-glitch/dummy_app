// ignore_for_file: unused_local_variable, unused_element, unnecessary_null_comparison
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/Components/card_content.dart';
import 'package:delivoo/Components/common_home_nav_bar.dart';
import 'package:delivoo/Components/reusable_card.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/saved_addresses_page.dart';
import 'package:delivoo/HomeOrderAccount/Account/UI/ListItems/updateaddresses.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/Address_provider.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Providers.dart/banner_provider.dart';
import 'package:delivoo/Providers.dart/category_provider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/geo/LocationProvider.dart';
import 'package:delivoo/geo/map_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../AppConstants.dart';
import '../../../CommonWidget.dart';
import '../../../Components/loading_shimmer.dart';
import '../../../Pages/Coupon/refferal_page.dart';

import '../../../Providers.dart/OrderProvider.dart';
import '../../../Providers.dart/login_provider.dart';
import '../../../main.dart';
import '../../home_order_account.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ApiProvider apiProvider = ApiProvider();
  DateTime? currentBackPressTime;
  late ConfettiController controllerLeft;
  late ConfettiController controllerRight;
  var fcmToken, os, deviceId;

  @override
  void initState() {
    super.initState();
    controllerLeft = ConfettiController(duration: const Duration(seconds: 10));
    controllerRight = ConfettiController(duration: const Duration(seconds: 10));
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    context.read<LocationServiceProvider>().getLocationAccess();

    getDetails();

    notification();

    getFirstRequest();

  }

  notification() async {

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {}
    });

    //Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? apple = message.notification?.apple;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              icon: "app_icon",
              channelShowBadge: true,
              playSound: true,
            ),
          ),
        );
      } else if (notification != null && apple != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              iOS: DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true)),
        );
      }
    });
    //background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //background message event here
    });
    // await navigatorKey.currentState?.context
    //     .read<Orderprovider>()
    //     .getorders("", "", "", 1);
  }

  getDetails() async {

    fcmToken = await context.read<LoginProvider>().getFcmToken();
    os = await context.read<LoginProvider>().getOS();
    deviceId = await context.read<LoginProvider>().initPlatformState();
    print('fcm-------->$fcmToken');
    print('os--------->$os');
    print('deviceId---------->$deviceId');
    await context.read<LoginProvider>().getdevicedetails("1");
    // await context.read<LoginProvider>().checkOnlineOrder();
    // context.read<Bannerprovider>().isload = false;
  }

  Future<void> getFirstRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = await prefs.getString('locationisON');
    if (Platform.isIOS) {
      // await askLocationPermisson();
    }
    addressUpdate();
    Future.delayed(const Duration(milliseconds: 500), () {
      checkIsLocationOn(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerLeft.dispose();
    controllerRight.dispose();
  }

  addressUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Location().getLocation().then((value) async {
      await prefs.setString('locationisON', 'true');
    });
  }

  checkIsLocationOn(bool setTrueForLoading) async {
    print("MAHESH location");
    showLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = await prefs.getString('locationisON');
    if (value == 'true') {
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

          // await context.read<LocationServiceProvider>().storeStatus == "1"
          //     ? position.latitude == null || position.longitude == null
          //     || position.latitude == "" || position.longitude == ""
          //     ? ""
          //     : await context.read<Addressprovider>().updateNewLocation(addr1: "",
          //     addr2: "", address: context.read<LocationServiceProvider>().getAddress,
          //     title: "", lat: position.latitude, long: position.longitude,
          //     pincode: context.read<LocationServiceProvider>().userAddressPinCode,
          //     addId: context.read<Addressprovider>().selectedAddress?.addressId,
          //     Action: "7")
          //     : context.read<Addressprovider>().showLocationDialog == false
          //     ? null
          //     : LocationChangeAlert(context.read<LocationServiceProvider>().getAddress, false);

          if (await context.read<LocationServiceProvider>().storeStatus == "1") {
            if (position.latitude == null ||
                position.longitude == null ||
                position.latitude == "" ||
                position.longitude == "") {
              return "";
            } else {
              return await context.read<Addressprovider>().updateNewLocation(
                  addr1: "",
                  addr2: "",
                  address: context.read<LocationServiceProvider>().getAddress,
                  title: "",
                  lat: position.latitude,
                  long: position.longitude,
                  pincode: context.read<LocationServiceProvider>().userAddressPinCode,
                  addId: context.read<Addressprovider>().selectedAddress?.addressId,
                  Action: "7"
              );
            }
          } else {
            if (context.read<Addressprovider>().showLocationDialog == false) {
              return null;
            } else {
              return LocationChangeAlert(
                  context.read<LocationServiceProvider>().getAddress,
                  false
              );
            }
          }

        }
      });
    }

    if (prefs.getString('orderid') != '' &&
        prefs.getString('orderid') != null) {
      await context.read<ProductProvider>().getcartitems();
    }
    prefs.getString("warehouseid") != null &&
        prefs.getString("warehouseid") != ""
        ? await context.read<StoreProvider>().getThestore(isLoad: false)
        : await context.read<StoreProvider>().getstoredetailsbyaddressid(
        addressid:
        context.read<Addressprovider>().selectedAddress?.addressId,
        loading: false);
    var storeid = context.read<StoreProvider>().stores?.d?.length == 0
        ? ""
        : await context.read<StoreProvider>().selectstore(
        "${context.read<StoreProvider>().stores?.d?[0].wareHouseId}");
    context.read<ProductProvider>().instorepickup = false;

    if (context.read<StoreProvider>().stores?.d?.length == 0 &&
        context.read<ProductProvider>().cartitems?.d?.isNotEmpty == true) {
      await context.read<ProductProvider>().removeallProducts();
      context.read<StoreProvider>().refresh();
    } else if (context.read<StoreProvider>().stores?.d?.length != 0 &&
        context.read<StoreProvider>().stores?.d?[0].wareHouseId !=
            prefs.getString("warehouseid") &&
        context.read<ProductProvider>().cartitems?.d?.isNotEmpty == true) {
      await context.read<ProductProvider>().removeallProducts();
      await context.read<StoreProvider>().refresh();
    }
    await allapi();
  }

  allapi() async {

    await context.read<Addressprovider>().getaddresses(isload: false);
    context.read<StoreProvider>().fromallstoresselected = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (context.read<Addressprovider>().selectedAddress != null) {
      if (context.read<Addressprovider>().selectedAddress?.latitude == '' ||
          context.read<Addressprovider>().selectedAddress?.longitude == '' ||
          context.read<Addressprovider>().selectedAddress?.latitude == null) {
        await context.read<LocationServiceProvider>().getLocationAccess();
        context.read<Addressprovider>().addrediting = true;
        await context.read<Addressprovider>().updatelocation(
            context.read<Addressprovider>().selectedAddress?.address1,
            context.read<Addressprovider>().selectedAddress?.address2,
            context.read<Addressprovider>().selectedAddress?.address,
            context.read<Addressprovider>().selectedAddress?.title,
            context.read<LocationServiceProvider>().getLatitude(),
            context.read<LocationServiceProvider>().getLongitude(),
            context.read<Addressprovider>().selectedAddress?.pincode,
            context.read<Addressprovider>().selectedAddress?.addressId,
            context.read<Addressprovider>().selectedAddress?.locationId,
            context.read<Addressprovider>().selectedAddress?.CityId
        );
        await context
            .read<LocationServiceProvider>()
            .showPlacePicker(context)
            .then((value) async {
          print('value: $value');
          context.read<LocationServiceProvider>().address =
          await value.toString();
          await context.read<Addressprovider>().updatelocation(
              context.read<Addressprovider>().selectedAddress?.address1,
              context.read<Addressprovider>().selectedAddress?.address2,
              context.read<Addressprovider>().selectedAddress?.address,
              context.read<Addressprovider>().selectedAddress?.title,
              context.read<LocationServiceProvider>().getLatitude(),
              context.read<LocationServiceProvider>().getLongitude(),
              context.read<Addressprovider>().selectedAddress?.pincode,
              context.read<Addressprovider>().selectedAddress?.addressId,
              context.read<Addressprovider>().selectedAddress?.locationId,
              context.read<Addressprovider>().selectedAddress?.CityId
          );
          await context.read<Addressprovider>().getaddresses(isload: false);
        });
      }
      prefs.getString("warehouseid") != null &&
          prefs.getString("warehouseid") != ""
          ? await context.read<StoreProvider>().getThestore(isLoad: false)
          : await context.read<StoreProvider>().getstoredetailsbyaddressid(addressid: context.read<Addressprovider>().selectedAddress?.addressId, loading: false);

      var storeid = context.read<StoreProvider>().stores?.d?.length == 0
          ? ""
          : await context.read<StoreProvider>().selectstore(
          "${context.read<StoreProvider>().stores?.d?[0].wareHouseId}");

      context.read<ProductProvider>().instorepickup = false;

      if (prefs.getString('orderid') != '' &&
          prefs.getString('orderid') != null) {
        await context.read<ProductProvider>().getcartitems();
      }

      await context
          .read<CategoryProvider>()
          .getCategory(isload: false, shopid: prefs.getString("shopid"));
      await context.read<Bannerprovider>().getbanners(isLoad: false);
      await context.read<Bannerprovider>().popupbanner();
      await context.read<StoreProvider>().refresh();

    }

    hideLoading();

    if (context.read<Addressprovider>().selectedAddress == null) {
      showModalBottomSheet(
        isDismissible: context.read<Addressprovider>().selectedAddress != null
            ? true
            : false,
        context: context,
        builder: (context) {
          return BottomWidget();
        },
      );
    }

    if (context.read<Bannerprovider>().flashImg != null &&
        context.read<Bannerprovider>().flashImg?.d != null &&
        context.read<Bannerprovider>().flashImg?.d!.length != 0 &&
        prefs.getString("isFirst") == "true") {
      popbanner(context.read<Bannerprovider>().flashImg?.d![0].bannerimg,
          controllerLeft, controllerRight);
      controllerLeft.play();
      controllerRight.play();
      Future.delayed(Duration(seconds: 1), () {
        controllerLeft.stop();
        controllerRight.stop();
      });
      prefs.setString("isFirst", "false");
    }
  }

  var _bcurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    final stores = context.watch<StoreProvider>().stores?.d;
    String? value = appLocalization.homeText;
    final categories = context.watch<CategoryProvider>().categories?.d;
    var height = MediaQuery.of(context).size.height;
    final banners = context.watch<Bannerprovider>().banners?.d;

    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 3)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(
              msg: "Press again to exit",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: RefreshIndicator(
        displacement: 90.0,
        color: kMainColor,
        onRefresh: () async {
          context.read<Addressprovider>().setLocationDialog(true);
          addressUpdate();
          Future.delayed(const Duration(milliseconds: 500), () {
            checkIsLocationOn(false);
          });
        },
        child: Scaffold(
          appBar: CommonHomeNavBar(
            titleWidget: Column(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Consumer<Addressprovider>(
                            builder: (context, model, _) {
                              return InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    isDismissible: context
                                        .read<Addressprovider>()
                                        .selectedAddress !=
                                        null
                                        ? true
                                        : false,
                                    context: context,
                                    builder: (context) {
                                      return BottomWidget();
                                    },
                                  );
                                },
                                child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                      MediaQuery.of(context).size.width * 0.60,
                                    ),
                                    // color: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    // width: MediaQuery.of(context).size.width * 0.65,
                                    decoration: BoxDecoration(
                                        color: Colors.black26,
                                        //kMainColor.withOpacity(0.075)

                                        borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                          ),
                                          child: Text(
                                              context
                                                  .watch<Addressprovider>()
                                                  .selectedAddress
                                                  ?.title ??
                                                  'Choose a location',
                                              style: TextStyle(fontSize: 14, color: Colors.white),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Icon(Icons.keyboard_arrow_down, color: Colors.white)
                                      ],
                                    )),
                              );
                            }),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () async {
                            context.read<Addressprovider>().setLocationDialog(
                                true); //this is to show new location pop up if value is true it shows the pop up
                            addressUpdate();
                            Future.delayed(const Duration(milliseconds: 500), () {
                              checkIsLocationOn(true);
                            });
                          },
                          child: context.watch<Addressprovider>().isLoading ||
                              context.watch<StoreProvider>().isLoading
                              ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: buttonColor,
                              ))
                              : Icon(Icons.refresh, color: Colors.white))
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.90,
                    ),
                    child: context.watch<Addressprovider>().selectedAddress == null
                        ? Text("")
                        : Text(context.watch<Addressprovider>().selectedAddress != null
                        && context.watch<Addressprovider>().selectedAddress!.address != null
                        && context.watch<Addressprovider>().selectedAddress!.address != ''
                        ? context.watch<Addressprovider>().selectedAddress!.address1 != null ? "${ context.watch<Addressprovider>().selectedAddress!.address1}, ${context.watch<Addressprovider>().selectedAddress!.address2}, ${ context.watch<Addressprovider>().selectedAddress!.address!}" : context.watch<Addressprovider>().selectedAddress!.address!
                        : "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis)),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.shopping_cart,
                            color: Colors.white, size: 35),
                        onPressed: () async {
                          context.read<ProductProvider>().getcartitems();
                          context.read<ProductProvider>().getcarttotal();
                          Navigator.pushNamed(context, PageRoutes.viewCart);
                        }),
                    PositionedDirectional(
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            context.watch<ProductProvider>().cartitems?.d !=
                                null
                                ? context
                                .watch<ProductProvider>()
                                .numberOfItems
                                .toString()
                                : '0',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      top: 2,
                      end: 5,
                    )
                  ],
                ),
              ),
            ],
            bottom: PreferredSize(child: Container(), preferredSize: Size.fromHeight(0.0)),
          ),
          body: context.watch<StoreProvider>().isLoading
              ? LoadingShimmer()
              : stores?.length == 1 ||
              context.watch<StoreProvider>().storeselected == true
              ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: banners != null
                  ? Column(
                children: [
                  //Banner Section
                  CarouselSlider(
                      options: CarouselOptions(
                        height: height * 0.2,
                        viewportFraction: 1,
                        aspectRatio: 2,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        pauseAutoPlayOnManualNavigate: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _bcurrentIndex = index;
                          });
                        },
                      ),
                      items: banners.map((item) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            width: MediaQuery.of(context)
                                .size
                                .width,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.0),
                            child: _buildItem(
                              BaseUrl +
                                  'banners/' +
                                  item.bannerimg!,
                              item.bannreid!,
                            ),
                          ),
                        );
                      }).toList()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: banners.map((dots) {
                      int index = banners.indexOf(dots);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                            Border.all(color: Colors.black),
                            color: _bcurrentIndex == index
                                ? buttonColor
                                : Colors.white),
                      );
                    }).toList(),
                  ),
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      await context
                          .read<LoginProvider>()
                          .checkAvailableRefferal(
                          pincode: context
                              .read<Addressprovider>()
                              .selectedAddress!
                              .pincode,
                          membershipno: await prefs
                              .getString('com_id'));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReferralSceen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          BaseUrl +
                              "Couponimg/Kisanserv_Referral_Banner.png",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      physics: ScrollPhysics(),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio:
                          MediaQuery.of(context)
                              .size
                              .width /
                              (MediaQuery.of(context)
                                  .size
                                  .height /
                                  2),
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4),
                      primary: true,
                      shrinkWrap: true,
                      itemCount: categories!.length,
                      itemBuilder: (context, index) {
                        return Opacity(
                          opacity:
                          categories[index].catStatus == '0'
                              ? 0.5
                              : 1,
                          child: ReusableCard(
                              cardChild: CardContent(
                                image: categories[index]
                                    .catimg !=
                                    null &&
                                    categories[index]
                                        .catimg !=
                                        ''
                                    ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      BaseUrl +
                                          SUBCAT_IMAGES +
                                          categories[
                                          index]
                                              .catimg
                                              .toString(),
                                      cacheKey:
                                      categories[
                                      index]
                                          .catimg),
                                  onError: (exception,
                                      stackTrace) {
                                    categories[index]
                                        .catimg = null;
                                  },
                                )
                                    : DecorationImage(
                                    image: AssetImage(
                                        'images/logos/not-available.png')),
                                text: categories[index].catName,
                              ),
                              onPress: () async {
                                SharedPreferences prefs =
                                await SharedPreferences
                                    .getInstance();
                                await navigatorKey
                                    .currentState!.context
                                    .read<ProductProvider>()
                                    .getTabIndex(index);
                                print("category tapped");

                                if (categories[index]
                                    .catStatus ==
                                    '1') {

                                  if (navigatorKey.currentContext!.read<StoreProvider>().stores?.d?[0].IsHoliday == "1") {

                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('catId', categories[index].catid.toString());
                                    prefs.setString("sectionId", categories[index].sectionid);
                                    String? status = await navigatorKey.currentState!.context.read<CategoryProvider>().getSubcategory(categories[index].catid);
                                    if (status == "true") {
                                      await navigatorKey.currentContext!
                                          .read<ProductProvider>().getProductsByCategory(sectiontId: categories[index].sectionid, searchtxt: '', catId: categories[index].catid,);

                                      var subcat = navigatorKey.currentContext!.read<CategoryProvider>().subcategories?.d;
                                      if (subcat != null &&
                                          subcat.length
                                              .toString() !=
                                              '0' &&
                                          navigatorKey
                                              .currentState!
                                              .context
                                              .read<
                                              Addressprovider>()
                                              .selectedAddress
                                              ?.latitude !=
                                              '') {
                                        Navigator.pushNamed(
                                            navigatorKey
                                                .currentState!
                                                .context,
                                            PageRoutes.items);
                                        // navigatorKey
                                        //     .currentState!.context
                                        //     .read<
                                        //         ProductProvider>()
                                        //     .getcarttotal();
                                      } else if (subcat?.length
                                          .toString() ==
                                          '0') {
                                      } else if (context
                                          .read<
                                          Addressprovider>()
                                          .selectedAddress
                                          ?.latitude ==
                                          '') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SavedAddressesPage()));
                                        showMessageDialog(context,
                                            'Please fill your complete address');
                                      }
                                    }
                                  } else {
                                    showDialog(
                                        context: navigatorKey
                                            .currentContext!,
                                        builder: (context) =>
                                            Center(
                                                child:
                                                AlertDialog(
                                                  backgroundColor:
                                                  Theme.of(
                                                      context)
                                                      .cardColor,
                                                  content: Material(
                                                      color: Theme.of(
                                                          context)
                                                          .cardColor,
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            height:
                                                            300,
                                                            width:
                                                            300,
                                                            padding:
                                                            EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                                shape:
                                                                BoxShape.rectangle,
                                                                color: Colors.white),
                                                            child: Image.asset(
                                                                'images/logos/Store-Closed.jpeg'),
                                                          ),
                                                          navigatorKey.currentState!.context.read<StoreProvider>().stores?.d?[0].opentime == null ||
                                                              navigatorKey.currentState!.context.read<StoreProvider>().stores?.d?[0].opentime == "" ||
                                                              navigatorKey.currentState!.context.read<StoreProvider>().stores?.d?[0].closetime == "" ||
                                                              navigatorKey.currentState!.context.read<StoreProvider>().stores?.d?[0].closetime == null
                                                              ? SizedBox.shrink()
                                                              : PositionedDirectional(
                                                            start: 60,
                                                            bottom: 20,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text('${navigatorKey.currentContext!.read<StoreProvider>().stores?.d?[0].Holidaymsg}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                            buttonColor),
                                                        onPressed:
                                                            () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "Ok"))
                                                  ],
                                                )));
                                  }
                                }
                              }),
                        );
                      },
                    ),
                  ),
                ],
              )
                  : Container(),
            ),
          )
              : stores == null
              ? Container(
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
                    height: 90,
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: 100,
                      child: Image.asset(
                        'images/logos/Kisanserv.png',
                        height: 90,
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
                            fontSize: 8,
                          )),
                    ),
                  ],
                ),
                Spacer()
              ],
            ),
          )
              : stores != null && stores.length == 0
              ? Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Center(
                child: Stack(
                  children: [
                    Image.network(BaseUrl + NOSTORES_IMAGE),
                    Positioned(
                      bottom: -5,
                      right: 20,
                      left: 20,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.black,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white),
                                    borderRadius:
                                    BorderRadius.circular(
                                        10)),
                                backgroundColor:
                                Colors.redAccent,
                              ),
                              onPressed: () async {
                                await context
                                    .read<
                                    LocationServiceProvider>()
                                    .getLocationAccess();
                                context
                                    .read<
                                    LocationServiceProvider>()
                                    .showPlacePicker(context)
                                    .then((value) async {
                                  print('value: $value');

                                  context
                                      .read<
                                      LocationServiceProvider>()
                                      .address =
                                  await value.toString();
                                  await context
                                      .read<
                                      LocationServiceProvider>()
                                      .checkStoreFromLatLng(
                                      context: context,
                                      lat: context
                                          .read<
                                          LocationServiceProvider>()
                                          .getLatitude(),
                                      lng: context
                                          .read<
                                          LocationServiceProvider>()
                                          .getLongitude(),
                                      load: false);
                                  await context
                                      .read<
                                      LocationServiceProvider>()
                                      .storeStatus ==
                                      "1"
                                      ? await context.read<Addressprovider>().updateNewLocation(
                                      addr1: context
                                          .read<
                                          Addressprovider>()
                                          .selectedAddress
                                          ?.address1,
                                      addr2: context
                                          .read<
                                          Addressprovider>()
                                          .selectedAddress
                                          ?.address2,
                                      address:
                                      context
                                          .read<
                                          LocationServiceProvider>()
                                          .address,
                                      title: context
                                          .read<
                                          Addressprovider>()
                                          .selectedAddress
                                          ?.title,
                                      lat:
                                      context
                                          .read<
                                          LocationServiceProvider>()
                                          .getLatitude(),
                                      long: context
                                          .read<
                                          LocationServiceProvider>()
                                          .getLongitude(),
                                      pincode: context
                                          .read<
                                          Addressprovider>()
                                          .selectedAddress
                                          ?.pincode,
                                      addId: context
                                          .read<
                                          Addressprovider>()
                                          .selectedAddress
                                          ?.addressId,
                                      Action: "7")
                                      : LocationChangeAlert(
                                      context
                                          .read<
                                          LocationServiceProvider>()
                                          .address,
                                      false);

                                  if (context
                                      .read<
                                      Addressprovider>()
                                      .selectedAddress
                                      ?.addressId !=
                                      null) {
                                    SharedPreferences prefs =
                                    await SharedPreferences
                                        .getInstance();
                                    // prefs.getString(
                                    //             "warehouseid") !=
                                    //         null
                                    //     ? await context
                                    //         .read<StoreProvider>()
                                    //         .getThestore(
                                    //             isLoad: false)
                                    //     :
                                    await navigatorKey
                                        .currentState?.context
                                        .read<StoreProvider>()
                                        .getstoredetailsbyaddressid(
                                        addressid: navigatorKey
                                            .currentState
                                            ?.context
                                            .read<
                                            Addressprovider>()
                                            .selectedAddress
                                            ?.addressId,
                                        loading: false);

                                    if (navigatorKey
                                        .currentState
                                        ?.context
                                        .read<
                                        StoreProvider>()
                                        .stores
                                        ?.d
                                        ?.length ==
                                        0 &&
                                        navigatorKey
                                            .currentState
                                            ?.context
                                            .read<
                                            ProductProvider>()
                                            .cartitems
                                            ?.d
                                            ?.isNotEmpty ==
                                            true) {
                                      await navigatorKey
                                          .currentState?.context
                                          .read<
                                          ProductProvider>()
                                          .removeallProducts();
                                      navigatorKey
                                          .currentState?.context
                                          .read<StoreProvider>()
                                          .refresh();
                                    } else if (navigatorKey
                                        .currentState
                                        ?.context
                                        .read<
                                        StoreProvider>()
                                        .stores
                                        ?.d
                                        ?.length !=
                                        0 &&
                                        navigatorKey
                                            .currentState
                                            ?.context
                                            .read<
                                            StoreProvider>()
                                            .stores
                                            ?.d?[0]
                                            .wareHouseId !=
                                            prefs.getString(
                                                "warehouseid") &&
                                        navigatorKey
                                            .currentState
                                            ?.context
                                            .read<
                                            ProductProvider>()
                                            .cartitems
                                            ?.d
                                            ?.isNotEmpty ==
                                            true) {
                                      print(
                                          "shop Id  ${navigatorKey.currentState?.context.read<StoreProvider>().stores?.d?[0].wareHouseId.toString()}");
                                      print(
                                          "shop id ${prefs.getString("warehouseid")}");
                                      await navigatorKey
                                          .currentState?.context
                                          .read<
                                          ProductProvider>()
                                          .removeallProducts();

                                      await navigatorKey
                                          .currentState?.context
                                          .read<StoreProvider>()
                                          .refresh();
                                    }
                                    var storeid = navigatorKey
                                        .currentState
                                        ?.context
                                        .read<
                                        StoreProvider>()
                                        .stores
                                        ?.d
                                        ?.length ==
                                        0
                                        ? ""
                                        : await navigatorKey
                                        .currentState
                                        ?.context
                                        .read<
                                        StoreProvider>()
                                        .selectstore(
                                        "${navigatorKey.currentState?.context.read<StoreProvider>().stores?.d?[0].wareHouseId}");
                                    navigatorKey
                                        .currentState?.context
                                        .read<ProductProvider>()
                                        .instorepickup = false;
                                    print('hhhh$storeid');

                                    if (prefs.getString(
                                        'orderid') !=
                                        '' &&
                                        prefs.getString(
                                            'orderid') !=
                                            null) {
                                      navigatorKey
                                          .currentState?.context
                                          .read<
                                          ProductProvider>()
                                          .getcarttotal();
                                      await navigatorKey
                                          .currentState?.context
                                          .read<
                                          ProductProvider>()
                                          .getcartitems();
                                    }
                                    await navigatorKey
                                        .currentState?.context
                                        .read<
                                        CategoryProvider>()
                                        .getCategory(
                                        isload: true,
                                        shopid: storeid);
                                    await navigatorKey
                                        .currentState?.context
                                        .read<Bannerprovider>()
                                        .getbanners(
                                        isLoad: true);
                                  }
                                  await navigatorKey
                                      .currentState?.context
                                      .read<Addressprovider>()
                                      .getaddresses(
                                      isload: true);
                                });
                              },
                              icon: Icon(Icons.location_on),
                              label: BlinkAnimation(
                                text:
                                "Change location Using GPS",
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
              : Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 16.0, left: 20.0, right: 20.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!
                          .homeText1!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 15),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .homeText2!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              buildGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildGrid(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final stores = context.watch<StoreProvider>().stores?.d;
    final cartitems = context.watch<ProductProvider>().cartitems?.d;
    var appLocalization = AppLocalizations.of(context);

    return Expanded(
      child: stores != null
          ? Container(
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: stores.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Divider(
                    color: Theme.of(context).cardColor,
                    thickness: 8.0,
                  ),
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      if (stores[index].shopid !=
                          prefs.getString("shopid") &&
                          cartitems?.isNotEmpty == true) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => new AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: Text(
                              "Your cart will be cleared on changing the shop",
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () async {
                                  context
                                      .read<ProductProvider>()
                                      .removeallProducts();
                                  var storeid = await context
                                      .read<StoreProvider>()
                                      .selectstore(
                                      stores[index].wareHouseId!);
                                  context
                                      .read<ProductProvider>()
                                      .instorepickup = false;
                                  await context
                                      .read<CategoryProvider>()
                                      .getCategory(
                                      isload: true, shopid: storeid);
                                  print('hhhhhhhhhh$storeid');
                                  await context
                                      .read<Bannerprovider>()
                                      .getbanners(isLoad: true);

                                  Navigator.pop(context);
                                  context
                                      .read<StoreProvider>()
                                      .storeselected = true;
                                  context.read<StoreProvider>().refresh();
                                },
                                child: Text("Clear cart", style: TextStyle(color: Colors.white)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                  await SharedPreferences
                                      .getInstance();
                                  await context
                                      .read<CategoryProvider>()
                                      .getCategory(
                                      isload: true,
                                      shopid:
                                      prefs.getString("shopid"));
                                  print(
                                      'Shop id: ${prefs.getString("shopid")}');
                                  await context
                                      .read<Bannerprovider>()
                                      .getbanners(isLoad: true);
                                  //context.read<Offerprovider>().getoffers();
                                  Navigator.pop(context);
                                  context
                                      .read<StoreProvider>()
                                      .storeselected = true;
                                  context.read<StoreProvider>().refresh();
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             LandingPage()));
                                },
                                child: Text("Cancel", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        var r = await context
                            .read<StoreProvider>()
                            .selectstore(stores[index].wareHouseId!);
                        context.read<ProductProvider>().instorepickup =
                        false;
                        await context
                            .read<CategoryProvider>()
                            .getCategory(
                            isload: true,
                            shopid: stores[index].shopid);
                        await context
                            .read<Bannerprovider>()
                            .getbanners(isLoad: true);
                        context.read<StoreProvider>().storeselected =
                        true;
                        context.read<StoreProvider>().refresh();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 90,
                            decoration: BoxDecoration(
                              image: stores[index].shopimg != null
                                  ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                    BaseUrl +
                                        'companyImages/' +
                                        '${stores[index].shopimg}',
                                    cacheKey: stores[index].shopimg
                                  // fit: BoxFit.cover,
                                ),
                                onError: (exception, stackTrace) {
                                  stores[index].shopimg = null;
                                },
                              )
                                  : DecorationImage(
                                image: AssetImage(
                                  'images/logos/defaultstore.jpeg',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                      stores[index].shopName.toString(),
                                      maxLines: 3,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                          fontSize: 12,
                                          overflow:
                                          TextOverflow.ellipsis)),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  child: Text(
                                      stores[index].saddress.toString(),
                                      maxLines: 3,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                          fontSize: 12,
                                          overflow:
                                          TextOverflow.ellipsis)),
                                ),

                                Padding(
                                  padding:
                                  const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    stores[index].pincode.toString(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color: kMainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Contact : ${stores[index].mobileno.toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),

                                // SizedBox(height: 10.0),
                                stores[index].opentime != null &&
                                    stores[index].opentime != ''
                                    ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 22.0),
                                  child: Row(
                                    children: [
                                      Text(
                                          'Opens: ${stores[index].opentime.toString()}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      Spacer(),
                                      Text(
                                          'Closes: ${stores[index].closetime.toString()}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium)
                                    ],
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      )
          : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 50),
              Text(
                "Choose a location to see nearby stores",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () async {
                        await context
                            .read<LocationServiceProvider>()
                            .getLocationAccess();
                        context
                            .read<LocationServiceProvider>()
                            .showPlacePicker(context)
                            .then((value) async {
                          print('value: $value');

                          context.read<LocationServiceProvider>().address =
                          await value.toString();
                          await context
                              .read<LocationServiceProvider>()
                              .checkStoreFromLatLng(
                              context: context,
                              lat: context
                                  .read<LocationServiceProvider>()
                                  .getLatitude(),
                              lng: context
                                  .read<LocationServiceProvider>()
                                  .getLongitude(),
                              load: false);
                          await context
                              .read<LocationServiceProvider>()
                              .storeStatus ==
                              "1"
                              ? await context
                              .read<Addressprovider>()
                              .updateNewLocation(
                              addr1: context
                                  .read<Addressprovider>()
                                  .selectedAddress
                                  ?.address1,
                              addr2: context
                                  .read<Addressprovider>()
                                  .selectedAddress
                                  ?.address2,
                              address: context
                                  .read<LocationServiceProvider>()
                                  .address,
                              title: context
                                  .read<Addressprovider>()
                                  .selectedAddress
                                  ?.title,
                              lat: context
                                  .read<LocationServiceProvider>()
                                  .getLatitude(),
                              long: context
                                  .read<LocationServiceProvider>()
                                  .getLongitude(),
                              pincode: context
                                  .read<Addressprovider>()
                                  .selectedAddress
                                  ?.pincode,
                              addId: context
                                  .read<Addressprovider>()
                                  .selectedAddress
                                  ?.addressId,
                              Action: "7")
                              : LocationChangeAlert(
                              context
                                  .read<LocationServiceProvider>()
                                  .address,
                              false);

                          if (context
                              .read<Addressprovider>()
                              .selectedAddress
                              ?.addressId !=
                              null) {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            // prefs.getString("warehouseid") != null
                            //     ? await context
                            //         .read<StoreProvider>()
                            //         .getThestore(isLoad: false)
                            //     :
                            await navigatorKey.currentState?.context
                                .read<StoreProvider>()
                                .getstoredetailsbyaddressid(
                                addressid: navigatorKey
                                    .currentState?.context
                                    .read<Addressprovider>()
                                    .selectedAddress
                                    ?.addressId,
                                loading: false);
                            if (navigatorKey.currentState?.context
                                .read<StoreProvider>()
                                .stores
                                ?.d
                                ?.length ==
                                0 &&
                                navigatorKey.currentState?.context
                                    .read<ProductProvider>()
                                    .cartitems
                                    ?.d
                                    ?.isNotEmpty ==
                                    true) {
                              await navigatorKey.currentState?.context
                                  .read<ProductProvider>()
                                  .removeallProducts();
                              navigatorKey.currentState?.context
                                  .read<StoreProvider>()
                                  .refresh();
                            } else if (navigatorKey.currentState?.context
                                .read<StoreProvider>()
                                .stores
                                ?.d
                                ?.length !=
                                0 &&
                                navigatorKey.currentState?.context
                                    .read<StoreProvider>()
                                    .stores
                                    ?.d?[0]
                                    .wareHouseId !=
                                    prefs.getString("warehouseid") &&
                                navigatorKey.currentState?.context
                                    .read<ProductProvider>()
                                    .cartitems
                                    ?.d
                                    ?.isNotEmpty ==
                                    true) {
                              print(
                                  "shop Id  ${navigatorKey.currentState?.context.read<StoreProvider>().stores?.d?[0].wareHouseId.toString()}");
                              print(
                                  "shop id ${prefs.getString("warehouseid")}");
                              await navigatorKey.currentState?.context
                                  .read<ProductProvider>()
                                  .removeallProducts();
                              await navigatorKey.currentState?.context
                                  .read<StoreProvider>()
                                  .refresh();
                            }
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
                            }
                            await navigatorKey.currentState?.context
                                .read<CategoryProvider>()
                                .getCategory(isload: true, shopid: storeid);
                            await navigatorKey.currentState?.context
                                .read<Bannerprovider>()
                                .getbanners(isLoad: true);
                          }
                          await navigatorKey.currentState?.context
                              .read<Addressprovider>()
                              .getaddresses(isload: true);
                        });
                      },
                      icon: Icon(Icons.location_on),
                      label: BlinkAnimation(
                        text: "Change location Using GPS",
                      )),
                ],
              ),
            ],
          )),
    );
  }

  _buildItem(String imagePath, String title) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10.0,
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    imagePath,
                    // "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg",
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset('images/logos/not-available.png');
                      //const Text('Image Not Found');
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class BottomWidget extends StatefulWidget {
  final index;

  BottomWidget({this.index});

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Container(
                  color: kMainColor,
                  child: ListTile(
                    title: Text("Select an address",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select an address to view nearby stores',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 15, color: Colors.white)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: buttonColor,
                                ),
                                onPressed: () async {
                                  await context
                                      .read<LocationServiceProvider>()
                                      .getLocationAccess();

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  if(prefs.getString("mapFlag") == "Google") {

                                    context
                                        .read<LocationServiceProvider>()
                                        .showPlacePicker(context)
                                        .then((value) async {
                                      print('value: $value');

                                      context
                                          .read<LocationServiceProvider>()
                                          .address = await value.toString();
                                      await context
                                          .read<LocationServiceProvider>()
                                          .checkStoreFromLatLng(
                                          context: context,
                                          lat: context
                                              .read<LocationServiceProvider>()
                                              .getLatitude(),
                                          lng: context
                                              .read<LocationServiceProvider>()
                                              .getLongitude(),
                                          load: false);
                                      if (await context
                                          .read<LocationServiceProvider>()
                                          .storeStatus ==
                                          "1") {
                                        await context
                                            .read<Addressprovider>()
                                            .updateNewLocation(
                                            addr1: context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.address1,
                                            addr2: context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.address2,
                                            address: context
                                                .read<
                                                LocationServiceProvider>()
                                                .address,
                                            title: context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.title,
                                            lat:
                                            context
                                                .read<
                                                LocationServiceProvider>()
                                                .getLatitude(),
                                            long:
                                            context
                                                .read<
                                                LocationServiceProvider>()
                                                .getLongitude(),
                                            pincode: context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.pincode,
                                            addId: context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.addressId,
                                            Action: "7");
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                        LocationChangeAlert(
                                            context
                                                .read<LocationServiceProvider>()
                                                .address,
                                            false);
                                      }

                                      if (address != null) {
                                        SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                        await navigatorKey.currentState?.context
                                            .read<StoreProvider>()
                                            .getstoredetailsbyaddressid(
                                            addressid: navigatorKey
                                                .currentState?.context
                                                .read<Addressprovider>()
                                                .selectedAddress
                                                ?.addressId,
                                            loading: false);

                                        if (navigatorKey.currentState?.context
                                            .read<StoreProvider>()
                                            .stores
                                            ?.d
                                            ?.length ==
                                            0 &&
                                            navigatorKey.currentState?.context
                                                .read<ProductProvider>()
                                                .cartitems
                                                ?.d
                                                ?.isNotEmpty ==
                                                true) {
                                          await navigatorKey.currentState?.context
                                              .read<ProductProvider>()
                                              .removeallProducts();
                                          navigatorKey.currentState?.context
                                              .read<StoreProvider>()
                                              .refresh();
                                        } else if (navigatorKey
                                            .currentState?.context
                                            .read<StoreProvider>()
                                            .stores
                                            ?.d
                                            ?.length !=
                                            0 &&
                                            navigatorKey.currentState?.context
                                                .read<StoreProvider>()
                                                .stores
                                                ?.d?[0]
                                                .wareHouseId !=
                                                prefs.getString("warehouseid") &&
                                            navigatorKey.currentState?.context
                                                .read<ProductProvider>()
                                                .cartitems
                                                ?.d
                                                ?.isNotEmpty ==
                                                true) {
                                          print(
                                              "shop Id  ${navigatorKey.currentState?.context.read<StoreProvider>().stores?.d?[0].wareHouseId.toString()}");
                                          print(
                                              "shop id ${prefs.getString("warehouseid")}");
                                          await navigatorKey.currentState?.context
                                              .read<ProductProvider>()
                                              .removeallProducts();

                                          await navigatorKey.currentState?.context
                                              .read<StoreProvider>()
                                              .refresh();
                                        }
                                        var storeid = navigatorKey
                                            .currentState?.context
                                            .read<StoreProvider>()
                                            .stores
                                            ?.d
                                            ?.length ==
                                            0
                                            ? ""
                                            : await navigatorKey
                                            .currentState?.context
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
                                        }
                                        await navigatorKey.currentState?.context
                                            .read<CategoryProvider>()
                                            .getCategory(
                                            isload: false, shopid: storeid);
                                        await navigatorKey.currentState?.context
                                            .read<Bannerprovider>()
                                            .getbanners(isLoad: false);
                                      }
                                      await navigatorKey.currentState?.context
                                          .read<Addressprovider>()
                                          .getaddresses(isload: false);
                                    });

                                  } else {

                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));

                                  }
                                },
                                icon: Icon(Icons.location_on),
                                label: Text(
                                  "Current location \n Using GPS",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: addresses?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: addresses![index].adstatus == '1'
                                  ? kMainColor
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

                                            setState(() {
                                              address = addresses[index]
                                                  .addressId!
                                                  .toString();
                                            });

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
                                                      .selectedAddress
                                                      ?.CityId
                                              );
                                              context
                                                  .read<Addressprovider>()
                                                  .addrediting = true;
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
                                                        .selectedAddress
                                                        ?.CityId
                                                );

                                                print(context
                                                    .read<
                                                    LocationServiceProvider>()
                                                    .locationResult
                                                    ?.latLng?.latitude);
                                              });
                                            }

                                            await context
                                                .read<StoreProvider>()
                                                .getstoredetailsbyaddressid(
                                                addressid: addressid,
                                                loading: false);
                                            print('no stores');
                                            Navigator.pop(context);
                                            print('hhhhhhhhhh$addressid');

                                            var storeid = await context
                                                .read<StoreProvider>()
                                                .selectstore(
                                                stores![0].wareHouseId!);
                                            await context
                                                .read<StoreProvider>()
                                                .onTapped(0);
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
                                          child: Text("Clear cart", style: TextStyle(color: Colors.white)),
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
                                          child: Text("Cancel", style: TextStyle(color: Colors.white)),
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
                                            .selectedAddress
                                            ?.CityId
                                    );
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
                                              .selectedAddress
                                              ?.CityId
                                      );

                                      print(context
                                          .read<LocationServiceProvider>()
                                          .locationResult
                                          ?.latLng?.latitude);
                                    });
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
                                  await context
                                      .read<StoreProvider>()
                                      .onTapped(0);
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
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 4,
                                      top: 10,
                                      child: IconButton(
                                          onPressed: () {
                                            context
                                                .read<Addressprovider>()
                                                .addnewAdd = false;
                                            context
                                                .read<Addressprovider>()
                                                .addressindex = index;

                                            context
                                                .read<Addressprovider>()
                                                .addresstype =
                                                context
                                                    .read<Addressprovider>()
                                                    .addresses
                                                    ?.d![index]
                                                    .title;
                                            context
                                                .read<Addressprovider>()
                                                .addrediting = true;
                                            context
                                                .read<Addressprovider>()
                                                .addresses
                                                ?.d![index]
                                                .latitude ==
                                                ''
                                                ? context
                                                .read<
                                                LocationServiceProvider>()
                                                .showPlacePicker(context)
                                                .then((value) async {
                                              print('value: $value');

                                              context
                                                  .read<
                                                  LocationServiceProvider>()
                                                  .address = value.toString();

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateAddressesPage()));
                                            })
                                                : context
                                                .read<
                                                LocationServiceProvider>()
                                                .showPlacePickerwithstoredloc(
                                                context,
                                                context
                                                    .read<
                                                    Addressprovider>()
                                                    .addresses
                                                    ?.d![index]
                                                    .latitude,
                                                context
                                                    .read<
                                                    Addressprovider>()
                                                    .addresses
                                                    ?.d![index]
                                                    .longitude, context
                                                .read<
                                                Addressprovider>()
                                                .addresses
                                                ?.d![index]
                                                .address, context
                                                .read<
                                                Addressprovider>()
                                                .addresses
                                                ?.d![index]
                                                .pincode)
                                                .then((value) async {
                                              print('value: $value');

                                              context
                                                  .read<
                                                  LocationServiceProvider>()
                                                  .address = value.toString();

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateAddressesPage()));
                                            });
                                          },
                                          icon: Icon(Icons.edit),
                                          color: buttonColor),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            addresses[index].title == "Home"
                                                ? Icon(
                                              Icons.home,
                                              color: Colors.red,
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
                                                    FontWeight.w500)),
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
                                              padding: const EdgeInsets.only(
                                                  right: 2.0),
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
                                                      addresses[index]
                                                          .address !=
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
                                              padding: const EdgeInsets.only(
                                                  right: 2.0),
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
                                                      style: TextStyle(
                                                          fontSize: 10)),
                                                ],
                                              ),
                                            ),
                                          ],
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
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          address != null
              ? PositionedDirectional(
            bottom: 0,
            end: 30,
            child: Row(
              children: [
                TextButton(
                  child: Text(
                    'Add new',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () async {
                    context.read<Addressprovider>().addrediting = false;
                    context.read<Addressprovider>().addnewAdd = false;
                    context.read<Addressprovider>().addresstype = 'Other';

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    if(prefs.getString("mapFlag") == "Google") {

                      context
                          .read<LocationServiceProvider>()
                          .showPlacePicker(context)
                          .then((value) {
                        print('value: $value');
                        context.read<LocationServiceProvider>().address = value.toString();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UpdateAddressesPage()))
                            .then((value) async {
                          context
                              .read<Addressprovider>()
                              .setLocationDialog(false);
                          await context.read<StoreProvider>().onTapped(0);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeOrderAccount()),
                                  (route) => false);
                        });
                        //moveCamera();
                      });

                    } else {

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));

                    }
                    context.read<Addressprovider>().changecolor();
                  },
                ),
                SizedBox(width: 10),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.continueText!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    Navigator.pop(context);
                    // prefs.getString("warehouseid") != null
                    //     ? await context
                    //         .read<StoreProvider>()
                    //         .getThestore(isLoad: false)
                    //     :

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
                    }
                    await navigatorKey.currentState?.context
                        .read<CategoryProvider>()
                        .getCategory(isload: true, shopid: storeid);
                    await navigatorKey.currentState?.context
                        .read<Bannerprovider>()
                        .getbanners(isLoad: true);
                    await navigatorKey.currentState!.context
                        .read<Addressprovider>()
                        .getaddresses(isload: true);
                  },
                ),
              ],
            ),
          )
              : Container(),
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}