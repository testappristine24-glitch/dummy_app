import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Components/custom_appbar.dart';
import 'package:delivoo/Components/entry_field.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Maps/Components/address_type_button.dart';
import 'package:delivoo/OrderMapBloc/order_map_bloc.dart';
import 'package:delivoo/OrderMapBloc/order_map_state.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../map_utils.dart';

TextEditingController _addressController = TextEditingController();

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderMapBloc>(
      create: (context) => OrderMapBloc()..loadMap(),
      child: SetLocation(),
    );
  }
}

class SetLocation extends StatefulWidget {
  @override
  _SetLocationState createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
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

  bool isCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//          extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(126.0),
        child: CustomAppBar(
          titleWidget: Text(
            AppLocalizations.of(context)!.setLocation!,
            style: TextStyle(fontSize: 16.7),
          ),
          onTap: null,
          hint: AppLocalizations.of(context)!.enterLocation,
        ),
      ),
      body: FadedSlideAnimation(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            Container(
              height: isCard
                  ? MediaQuery.of(context).size.height * 0.45
                  : MediaQuery.of(context).size.height * 0.65,
              child: BlocBuilder<OrderMapBloc, OrderMapState>(
                  builder: (context, state) {
                    print('polyyyy' + state.polylines.toString());
                    return GoogleMap(
                      zoomControlsEnabled: false,
                      // polylines: state.polylines,
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
                          // _markers.add(
                          //   Marker(
                          //     markerId: MarkerId('mark2'),
                          //     position:
                          //         LatLng(37.42496133180663, -122.081743655960),
                          //     icon: markerss[0],
                          //   ),
                          // );
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
            ),
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'images/map_pin.png',
                    scale: 2.5,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Text(
                      'Paris, France',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            isCard ? SaveAddressCard() : Container(),
            BottomBar(
                text: AppLocalizations.of(context)!.continueText,
                onTap: () {
                  if (isCard == false) {
                    setState(() {
                      isCard = true;
                    });
                  } else {
                    Navigator.popAndPushNamed(
                        context, PageRoutes.homeOrderAccountPage);
                  }
                }),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

enum AddressType {
  Home,
  Office,
  Other,
}

AddressType selectedAddress = AddressType.Other;

class SaveAddressCard extends StatefulWidget {
  @override
  _SaveAddressCardState createState() => _SaveAddressCardState();
}

class _SaveAddressCardState extends State<SaveAddressCard> {
  @override
  Widget build(BuildContext context) {
    return FadedSlideAnimation(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: EntryField(
              controller: _addressController,
              label: AppLocalizations.of(context)!.addressLabel,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              AppLocalizations.of(context)!.saveAddress!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                AddressTypeButton(
                  label: AppLocalizations.of(context)!.homeText,
                  image: 'images/address/ic_homeblk.png',
                  onPressed: () {
                    setState(() {
                      selectedAddress = AddressType.Home;
                    });
                  },
                  isSelected: selectedAddress == AddressType.Home,
                ),
                AddressTypeButton(
                  label: AppLocalizations.of(context)!.office,
                  image: 'images/address/ic_officeblk.png',
                  onPressed: () {
                    setState(() {
                      selectedAddress = AddressType.Office;
                    });
                  },
                  isSelected: selectedAddress == AddressType.Office,
                ),
                AddressTypeButton(
                  label: AppLocalizations.of(context)!.other,
                  image: 'images/address/ic_otherblk.png',
                  onPressed: () {
                    setState(() {
                      selectedAddress = AddressType.Other;
                    });
                  },
                  isSelected: selectedAddress == AddressType.Other,
                ),
              ],
            ),
          )
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}