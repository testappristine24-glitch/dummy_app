// ignore_for_file: unused_local_variable, unused_element, unused_field, unnecessary_null_comparison

import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/AppConstants.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Providers.dart/Address_provider.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Providers.dart/banner_provider.dart';
import 'package:delivoo/Providers.dart/category_provider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Components/common_app_nav_bar.dart';
import '../../../../Components/common_home_nav_bar.dart';
import '../../../../Components/loading_shimmer.dart';

class AllStores extends StatefulWidget {
  @override
  _allStoresState createState() => _allStoresState();
}

class _allStoresState extends State<AllStores> {
  ApiProvider apiProvider = ApiProvider();

  @override
  void initState() {
    allapis();

    super.initState();
  }

  var _bcurrentIndex = 0;
  var warehouseID;
  allapis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    context.read<Addressprovider>().setLocationDialog(false); //this is to show new location pop up if value is true it shows the pop up
    context.read<StoreProvider>().fromallstoresselected = false;
    await context.read<StoreProvider>().getallstores(isLoad: false);
    warehouseID = prefs.getString("warehouseid");
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    String? value = appLocalization.homeText;
    final categories = context.watch<CategoryProvider>().categories?.d;
    var height = MediaQuery.of(context).size.height;
    final banners = context.watch<Bannerprovider>().banners?.d;
    final allstores = context.watch<StoreProvider>().allstores?.d;

    return WillPopScope(
      onWillPop: () {
        context.read<StoreProvider>().onTapped(0);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: CommonHomeNavBar(
            titleWidget: Container(),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.shopping_cart,
                            color: Colors.white, size: 35
                            //AssetImage('images/icons/ic_cart blk.png'),
                            ),
                        onPressed: () {
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

            /// hint: 'Search',
            bottom: PreferredSize(
                child: Container(),
                preferredSize: Size.fromHeight(
                    0.0)), // AppLocalizations.of(context)!.search,
          ),
        ),
        body: context.watch<Addressprovider>().isLoading ||
                context.watch<StoreProvider>().isLoading
            ? LoadingShimmer()
            : allstores == null
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
                : allstores != null && allstores.length == 0
                    ? Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Center(
                          child: Image.network(BaseUrl + NOSTORES_IMAGE),
                        ))
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 16.0, left: 20.0, right: 20.0, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)!.homeText1!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontSize: 15),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.homeText2!,
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
                          Padding(
                            padding: const EdgeInsets.only(left: 2, right: 2),
                            child: buildGrid(context),
                          ),
                        ],
                      ),
      ),
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
                fit: BoxFit.cover,
                width: 340,

                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('Image Not Found');
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  buildGrid(BuildContext ctx) {
    final categoryProvider = ctx.watch<CategoryProvider>();
    final allstores = ctx.watch<StoreProvider>().allstores?.d;
    final cartitems = ctx.watch<ProductProvider>().cartitems?.d;
    var appLocalization = AppLocalizations.of(ctx);

    return Container(
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: allstores?.length ?? 0,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Divider(
                  //   color: Theme.of(context).cardColor,
                  //   thickness: 8.0,
                  // ),
                  InkWell(
                    onTap: () async {
                      ctx.read<StoreProvider>().fromallstoresselected = true;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (allstores![index].wareHouseId !=
                              prefs.getString("warehouseid") &&
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
                                  ctx
                                      .read<ProductProvider>()
                                      .removeallProducts();
                                  var wareHouseId = await ctx
                                      .read<StoreProvider>()
                                      .selectstore(
                                          allstores[index].wareHouseId!);
                                  context
                                      .read<ProductProvider>()
                                      .instorepickup = false;

                                  ctx
                                      .read<StoreProvider>()
                                      .fromallstoresselected = true;

                                  await context.read<StoreProvider>().refresh();
                                  await context
                                      .read<StoreProvider>()
                                      .selectTheStore(
                                          isLoad: true,
                                          shopId: allstores[index].shopid,
                                          warehouseId:
                                              allstores[index].wareHouseId,
                                          storeLocation:
                                              allstores[index].storeLocationId);
                                  await context
                                      .read<StoreProvider>()
                                      .onTapped(0);
                                  Navigator.pop(context);
                                },
                                child: Text("Clear cart", style: TextStyle(color: Colors.white),),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel" , style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        context.read<ProductProvider>().instorepickup = false;
                        await ctx
                            .read<StoreProvider>()
                            .selectstore("${allstores[index].wareHouseId}");
                        ctx.read<StoreProvider>().refresh();
                        await context.read<StoreProvider>().selectTheStore(
                            isLoad: true,
                            shopId: allstores[index].shopid,
                            warehouseId: allstores[index].wareHouseId,
                            storeLocation: allstores[index].storeLocationId);

                        await ctx.read<StoreProvider>().onTapped(0);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        //  color: kMainColor,
                        color: allstores?[0].wareHouseId ==
                                allstores?[index].wareHouseId
                            ? kMainColor
                            : Colors.transparent,
                        boxShadow: allstores?[0].wareHouseId ==
                                allstores?[index].wareHouseId
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
                          color: allstores?[0].wareHouseId ==
                                  allstores?[index].wareHouseId
                              ? Colors.grey
                              : Colors.transparent,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment:
                          //     MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 90,
                              decoration: BoxDecoration(
                                image: allstores?[index].shopimg != null &&
                                        allstores?[index].shopimg != ''
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            BaseUrl +
                                                'companyImages/' +
                                                allstores![index].shopimg!,
                                            cacheKey: allstores[index].shopimg
                                            // fit: BoxFit.cover,
                                            ),
                                        onError: (exception, stackTrace) {
                                          allstores[index].shopimg = null;
                                          context
                                              .read<StoreProvider>()
                                              .refresh();
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                        allstores![index].shopName.toString() +
                                            " ${double.parse(allstores[index].skm ?? "").toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}" +
                                            "${allstores[index].skm == null || allstores[index].skm == "" ? "" : "km"}",
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
                                        allstores[index].saddress.toString(),
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
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      allstores[index].pincode.toString(),
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
                                    'Contact: ${allstores[index].mobileno.toString()}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),

                                  // SizedBox(height: 10.0),
                                  allstores[index].opentime != null &&
                                          allstores[index].opentime != ''
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.62,
                                                    child: Text(
                                                        'Opens: ${allstores[index].opentime.toString()}  Closes: ${allstores[index].closetime.toString()}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!),
                                                  ),
                                                ],
                                              ),
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
                  ),
                ],
              ),
            );
          }),
    );
  }
}
