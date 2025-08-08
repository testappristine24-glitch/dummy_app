import 'dart:convert';
import 'dart:io';
import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/AppConstants.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/geo/MapMyIndiaLocationServiceProvider.dart';
import 'package:delivoo/main.dart';
import 'package:flutter/material.dart';
import 'package:delivoo/geo/place_picker.dart' as placePicker;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:place_picker/place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo/AppConstants.dart' as Appconstants;

import '../HomeOrderAccount/Account/UI/ListItems/updateaddresses.dart';
import 'GoogleLocationProvider.dart';

class LocationServiceProvider extends ChangeNotifier {

  final ApiProvider apiProvider = ApiProvider();
  Location location = new Location();
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  bool? _serviceEnabled;
  bool _loading = true;

  LocationResult? locationResult;
  var _timeCalculate;
  var _formattedAddress;
  var userAddressPinCode;
  get getLocationData => locationResult;
  get getTimeCalculate => _timeCalculate;
  get getAddress => _formattedAddress;
  get getUserPinCode => userAddressPinCode;

  bool? get serviceEnabled => _serviceEnabled;
  bool get isLoading => _loading;
  String? address;
  var storeStatus = "1";

  Future<void> getLocationAccess() async {
    try {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled!) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled!) {
          return;
        }
      }

      // Fetch initial location
      locationData = await location.getLocation();

      // Listen for location changes
      location.onLocationChanged.listen((LocationData newLocation) {
        locationData = newLocation;
        notifyListeners(); // Notify UI to update
      });

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      print("Error fetching location: $e");
    }
  }

  showPlacePicker(context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("mapFlag") == "Google") {
      try {
        await getLocationAccess();
        LocationResult result = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) {
          return placePicker.PlacePicker(GoogleApiKey);
        }));
        // ignore: unnecessary_null_comparison

        locationResult = result;
        _formattedAddress = result.formattedAddress;
        address = _formattedAddress;
        userAddressPinCode = result.postalCode;
        print(locationResult);
        print('llllllllllatitude${userAddressPinCode}');
        print('llllllllllatitude${result.latLng?.latitude}');
        print('llllllllllongitude${result.latLng?.longitude}');
        print(_formattedAddress);
        notifyListeners();
        return _formattedAddress;
      } on Exception {}
    }
  }

  showPlacePickerwithstoredloc(context, lat, lng, address, pincode) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("mapFlag") == "Google") {

      print('MAHESH EDIT ADDRESS: $lat $lng');

      locationResult?.latLng = LatLng(double.parse(lat), double.parse(lng));
      _formattedAddress = address ?? '';  // Handle potential nulls
      address = _formattedAddress;
      userAddressPinCode = pincode;
      print('Formatted Address: $_formattedAddress');
      print('Postal Code: $userAddressPinCode');
      notifyListeners();

      print("Navigating to PlacePicker...");
      LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return placePicker.PlacePicker(
              GoogleApiKey,
              displayLocation: LatLng(double.parse(lat), double.parse(lng)),
            );
          },
        ),
      );

      print("Navigating from PlacePicker...");
      locationResult = result;
      _formattedAddress = result.formattedAddress;  // Handle potential nulls
      address = _formattedAddress;
      userAddressPinCode = result.postalCode;
      print('Formatted Address: $_formattedAddress');
      print('Postal Code: $userAddressPinCode');
      notifyListeners();

      return _formattedAddress;

    } else {

    }
  }

  getAddressFromLatLng({@required context, double? lat, double? lng}) async {

    print("CALLED getAddressFromLatLng");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString("mapFlag") == "Google") {

      var formattedAddress = await navigatorKey.currentContext?.read<GoogleServiceProvider>()
          .getAddressFromLatLng(
          context: navigatorKey.currentContext, lat: lat, lng: lng);

      if(formattedAddress != null) {

        if(formattedAddress != "failed") {

          userAddressPinCode = navigatorKey.currentContext?.read<GoogleServiceProvider>().userAddressPinCode;
          print("HURRY");
          print(userAddressPinCode);
          print("END");
          _formattedAddress = formattedAddress;
          address = _formattedAddress;

        } else {

          print("ERROR MAPMYINDIA $formattedAddress");

          prefs.setString('mapFlag', "MapMyIndia");

          var formattedAddressNew = await navigatorKey.currentContext?.read<MapMyIndiaLocationServiceProvider>()
              .getAddressFromLatLng(
              context: context,
              lat: lat,
              lng: lng);

          if(formattedAddressNew != null) {

            if(formattedAddressNew != "failed") {

              print("RESPONSE MAP MY INDIA $formattedAddressNew");
              userAddressPinCode = navigatorKey.currentContext?.read<MapMyIndiaLocationServiceProvider>().userAddressPinCode;

              print("HURRY");
              print(userAddressPinCode);
              print("END");
              _formattedAddress = formattedAddressNew;
              address = _formattedAddress;

            } else {

              print("SHOWING POPUP");
              showLocationErrorDialog(navigatorKey.currentState!.context);

            }
          } else {

            print("SHOWING POPUP");
            showLocationErrorDialog(navigatorKey.currentState!.context);

          }
        }
      }
    } else {

      var formattedAddress = await navigatorKey.currentContext?.read<MapMyIndiaLocationServiceProvider>()
          .getAddressFromLatLng(
          context: context,
          lat: lat,
          lng: lng);

      if(formattedAddress != null) {

        if(formattedAddress != "failed") {

          userAddressPinCode = navigatorKey.currentContext?.read<MapMyIndiaLocationServiceProvider>().userAddressPinCode;

          print("HURRY");
          print(userAddressPinCode);
          print("END");

          _formattedAddress = formattedAddress;
          address = _formattedAddress;

        } else {

          print("ERROR MAPMYINDIA $formattedAddress");

          prefs.setString('mapFlag', "Google");
          var formattedAddressNew = await navigatorKey.currentContext?.read<GoogleServiceProvider>()
              .getAddressFromLatLng(
              context: navigatorKey.currentContext, lat: lat, lng: lng);

          if(formattedAddressNew != null) {

            if(formattedAddressNew != "failed") {

              userAddressPinCode = navigatorKey.currentContext?.read<GoogleServiceProvider>().userAddressPinCode;

              print("HURRY");
              print(userAddressPinCode);
              print("END");

              print("RESPONSE GOOGLE $formattedAddressNew");
              _formattedAddress = formattedAddressNew;
              address = _formattedAddress;

            } else {

              print("SHOWING POPUP");
              showLocationErrorDialog(navigatorKey.currentState!.context);

            }
          }else {

            print("SHOWING POPUP");
            showLocationErrorDialog(navigatorKey.currentState!.context);

          }
        }
      }
    }
  }

  void showLocationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Location Service",
            style: TextStyle(
              fontSize: 22, // Large title
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            "Location services are temporarily unavailable, please try again after sometime.",
            style: TextStyle(
              fontSize: 18, // Large content text
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  fontSize: 18, // Larger button text
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  checkStoreFromLatLng({@required context, double? lat,
    double? lng, bool? load}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        load == true ? showLoading() : "";
        print("latitiuddddddddddeeeeee ${lat}");
        print("longitudeeeeeeee ${lng}");
        String requestJson = jsonEncode({
          "curlatitude": "$lat",
          "curlongitude": "$lng",
          "membershipno": prefs.getString("com_id")
        });
        print("MAHESH LOCATION $requestJson");
        final response = await apiProvider.post(
            Appconstants.GET_StoreCheckList, requestJson);
        print('---------------getotp');
        print(response);
        storeStatus = response["d"] ?? "1";
        load == true ? hideLoading() : "";
        notifyListeners();
        return storeStatus;
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  getLatitude() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString("mapFlag") == "Google") {
    //   locationResult = await navigatorKey.currentContext
    //       ?.read<GoogleServiceProvider>()
    //       .getLatitude();
    // } else {
    //   locationResult = await navigatorKey.currentContext
    //       ?.read<MapMyIndiaLocationServiceProvider>()
    //       .getLatitude();
    // }

    if (locationResult != null) {
      print("location result not null");
      print(locationResult?.latLng?.latitude);
      return locationResult?.latLng?.latitude;
    } else if (locationData != null) {
      print("locationData not null");
      return locationData!.latitude;
    }
  }

  getLongitude() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString("mapFlag") == "Google") {
    //   if (locationResult != null) {
    //     print("location result not null");
    //     print(locationResult?.latLng?.latitude);
    //     return locationResult?.latLng?.latitude;
    //   } else if (locationData != null) {
    //     print("locationData not null");
    //     return locationData!.latitude;
    //   }
    // } else {
    //   locationResult = await navigatorKey.currentContext
    //       ?.read<MapMyIndiaLocationServiceProvider>()
    //       .getLongitude();
    // }

    if (locationResult != null) {
      print("location result not null");
      print(locationResult?.latLng?.longitude);
      return locationResult?.latLng?.longitude;
    } else if (locationData != null) {
      print("locationData not null");
      return locationData!.longitude;
    }
  }

  getLatitudeLongitude(double latitude, double longitude) {

    LatLng? mLatLng = LatLng(latitude, longitude);
    LocationResult mLocationResult = LocationResult();
    mLocationResult.latLng = mLatLng;
    return mLocationResult;

  }

  setAddressFromMap(String addressNew) {

    _formattedAddress = addressNew;
    address = _formattedAddress;

  }
}
