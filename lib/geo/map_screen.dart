import 'dart:convert';
import 'dart:math';
import 'package:delivoo/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show ByteData, PlatformException, rootBundle;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:place_picker/entities/entities.dart';

import '../Components/loading_shimmer_short.dart';
import '../HomeOrderAccount/Account/UI/ListItems/updateaddresses.dart';
import '../HomeOrderAccount/home_order_account.dart';
import '../Models/LocationModel.dart';
import '../Providers.dart/Address_provider.dart';
import '../Providers.dart/store_provider.dart';
import '../Themes/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:delivoo/geo/select_place_action.dart' as select_place;

import 'LocationProvider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late MapplsMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  LatLng? _currentLocation;
  List<ELocation> searchResults = [];

  String formattedAddress = "";
  double latitude = 0.0;
  double longitude = 0.0;
  var userAddressPinCode;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    // if (_searchController.text.isNotEmpty) {
    //   _searchPlace(_searchController.text);
    // } else {
    //   setState(() {
    //     searchResults = []; // Clear search results when text is empty
    //   });
    // }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Request location permission if not already granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    _mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
    _addMarker(_currentLocation!);
  }

  void _onMapCreated(MapplsMapController controller) async {

    hideLoading();

    _mapController = controller;

    if (_currentLocation != null) {
      _addMarker(_currentLocation!);
    }
  }

  void _onMapTap(Point<double> point, LatLng coordinates) {
    _mapController.clearSymbols();
    setState(() {
      _currentLocation = coordinates;
    });
    _addMarker(coordinates);
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return _mapController.addImage(name, list);
  }

  Future<void> _addMarker(LatLng coordinates) async {

    getAddressFromLatLong();
    await addImageFromAsset("icon", "images/map_pin.png");
    _mapController.addSymbol(SymbolOptions(
      geometry: coordinates, iconImage: "icon"
    ));
    print("Marker added");
  }

  Future<void> _searchPlace(String query) async {

    try {
      AutoSuggestResponse? response = await MapplsAutoSuggest(query: query).callAutoSuggest();
      if(response!.suggestedLocations!.isNotEmpty) {
        searchResults = response.suggestedLocations!;
        print("${response.suggestedLocations?[0].entryLatitude}");
        print("${response.suggestedLocations?[0].entryLongitude}");
        print("${response.suggestedLocations?[0].latitude}");
        print("${response.suggestedLocations?[0].longitude}");
        print("${response.suggestedLocations?[0].placeAddress}");
        print("${response.suggestedLocations?[0].placeName}");
      }
      setState(() {

      });
    } catch(e) {
      PlatformException map = e as PlatformException;
      print("Failed to load search results ${map.code}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: Stack(
        children: [
          MapplsMap(
            onMapCreated: _onMapCreated,
            onMapClick: _onMapTap,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search a place',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15.0),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            _searchPlace(_searchController.text);
                          },
                        ),
                      ),
                      onSubmitted: _searchPlace,
                    ),
                  ),
                  if (searchResults.isNotEmpty)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 400, // Set the max height
                          ),
                          child: ListView.builder(
                            shrinkWrap: true, // Makes the ListView shrink to fit content
                            physics: ClampingScrollPhysics(), // Prevents unnecessary scrolling
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final place = searchResults[index];
                              return ListTile(
                                title: Text(place.placeName ?? ''),
                                subtitle: Text(place.placeAddress ?? ''),
                                onTap: () {
                                  getLatLng(place.mapplsPin);
                                  searchResults = [];
                                  setState(() {

                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      child: Column(
                        children: [
                          formattedAddress == ""
                              ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Shimmer.fromColors(
                              baseColor: buttonColor,
                              highlightColor: Colors.grey[100]!,
                              enabled: true,
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15))),
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.location_on_outlined,
                                    color: kWhiteColor,
                                  ),
                                  label: Text("Get Current Location")),
                            ),
                          )
                              : Column(children: [
                            Container(
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15))),
                                  onPressed: () async {

                                  },
                                  icon: Icon(
                                    Icons.location_on_outlined,
                                    color: kWhiteColor,
                                  ),
                                  label: Text("Get Current Location")),
                            ),
                          ]),
                          formattedAddress == ""
                              ? Container(height: 50, child: LoadingShimmershort())
                              : Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              select_place.SelectPlaceAction(
                                  formattedAddress,
                                      () => SelectAddress(),
                                  'Tap to select this location'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getLatLng(String? mapplsPin) async {

    try {
      PlaceDetailResponse? response = await MapplsPlaceDetail(mapplsPin: mapplsPin!).callPlaceDetail();
      if(response != null) {
        LatLng coordinates = LatLng(response.latitude!, response.longitude!);
        _mapController.clearSymbols();
        setState(() {
          _currentLocation = coordinates;
        });
        _addMarker(coordinates);
        _mapController.animateCamera(
          CameraUpdate.newLatLng(coordinates),
        );
      }
    } catch(e) {
      PlatformException map = e as PlatformException;
      print(map.code);
    }
  }

  Future<void> getAddressFromLatLong() async {
    try {
      ReverseGeocodeResponse? result = await MapplsReverseGeocode(
          location: _currentLocation!).callReverseGeocode();
      if(result != null) {
        print("PLACE -- ${result.results?[0].formattedAddress}");
        formattedAddress = result.results![0].formattedAddress!;
        userAddressPinCode = result.results![0].pincode;
        setState(() {

        });
      }
    } catch (e) {
      print("ERROR -- ${e}");
      PlatformException map = e as PlatformException;
      print(map.code);
    }
  }

  SelectAddress() {

    context.read<LocationServiceProvider>().setAddressFromMap(formattedAddress);

    context.read<LocationServiceProvider>().address = formattedAddress;
    context.read<LocationServiceProvider>().userAddressPinCode = userAddressPinCode;
    context.read<LocationServiceProvider>().locationResult = context.read<LocationServiceProvider>()
        .getLatitudeLongitude(_currentLocation!.latitude, _currentLocation!.longitude);

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
  }
}

