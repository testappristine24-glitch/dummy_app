import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/HomeOrderAccount/Home/UI/slide_up_panel.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/OrderMapBloc/order_map_bloc.dart';
import 'package:delivoo/OrderMapBloc/order_map_state.dart';
import 'package:delivoo/Providers.dart/OrderProvider.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMapPage extends StatelessWidget {
  final String? instruction;
  final String? pageTitle;

  OrderMapPage({this.instruction, this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderMapBloc>(
      create: (context) => OrderMapBloc()..loadMap(),
      child: OrderMap(pageTitle),
    );
  }
}

class OrderMap extends StatefulWidget {
  final String? pageTitle;

  OrderMap(this.pageTitle);

  @override
  _OrderMapState createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapStyleController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    rootBundle.loadString('images/map_style.txt').then((string) {
      mapStyle = string;
    });
    super.initState();
  }

  List<String> itemName = [
    'Fresh Red Onions',
    'Fresh Cauliflower',
    'Fresh Cauliflower',
  ];

  @override
  Widget build(BuildContext context) {
    final orderdetails = context.watch<Orderprovider>().orderdetails?.d;
    return FadedSlideAnimation(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(160.0),
          child: AppBar(
            //titleSpacing: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {},
            ),
            leadingWidth: 100,
            title: null,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: /*  Image.asset(
                          'images/maincategory/vegetables_fruitsact.png',
                          height: 42.3,
                          width: 33.7,
                        ), */
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context)!.vegetable!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                letterSpacing: 0.07,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '20 June, 11:35am',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                fontSize: 11.7,
                                letterSpacing: 0.06,
                                color: Color(0xffc1c1c1)),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.pickup!,
                                style: orderMapAppBarTextStyle.copyWith(
                                    color: kMainColor),
                              ),
                              SizedBox(height: 7.0),
                              Text(
                                //  '\$ 11.50 | ${AppLocalizations.of(context)!.paypal}',
                                '\u{20B9}  ${context.watch<Orderprovider>().selectedOrder?.totalamount} | ${context.watch<Orderprovider>().selectedOrder?.paymentmode}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                    fontSize: 11.7,
                                    letterSpacing: 0.06,
                                    color: Color(0xffc1c1c1)),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).cardColor,
                    thickness: 1.0,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 36.0, bottom: 6.0, top: 6.0, right: 12.0),
                        child: Icon(
                          Icons.location_on,
                          color: kMainColor,
                          size: 13.3,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.store!,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 10.0,
                            letterSpacing: 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' (Union Market)',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 10.0, letterSpacing: 0.05),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 36.0, bottom: 12.0, top: 12.0, right: 12.0),
                        child: Icon(
                          Icons.navigation,
                          color: kMainColor,
                          size: 13.3,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.homeText!,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 10.0,
                            letterSpacing: 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' (${context.watch<Orderprovider>().selectedOrder?.delAddress})',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 10.0, letterSpacing: 0.05),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  BlocBuilder<OrderMapBloc, OrderMapState>(
                      builder: (context, state) {
                        print('polyyyy' + state.polylines.toString());
                        return GoogleMap(
                          zoomControlsEnabled: false,
                          polylines: state.polylines,
                          mapType: MapType.normal,
                          initialCameraPosition: kGooglePlex,
                          markers: _markers,
                          onMapCreated: (GoogleMapController controller) async {
                            _mapController.complete(controller);
                            mapStyleController = controller;
                            mapStyleController!.setMapStyle(mapStyle);
                            setState(() {
                              _markers.add(
                                Marker(
                                  markerId: MarkerId('mark1'),
                                  position:
                                  LatLng(37.42796133580664, -122.085749655962),
                                  icon: markerss.first,
                                ),
                              );
                              _markers.add(
                                Marker(
                                  markerId: MarkerId('mark2'),
                                  position:
                                  LatLng(37.42496133180663, -122.081743655960),
                                  icon: markerss[0],
                                ),
                              );
                              // _markers.add(
                              //   Marker(
                              //     markerId: MarkerId('mark3'),
                              //     position:
                              //         LatLng(37.42196183580660, -122.089743655967),
                              //     icon: markerss[0],
                              //   ),
                              // );
                            });
                          },
                        );
                      }),
                  SlideUpPanel(itemName),
                ],
              ),
            ),
            Container(
              height: 60.0,
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${orderdetails?.length} items',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}