import 'dart:convert';
import 'dart:io';
import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/AppConstants.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:delivoo/geo/place_picker.dart' as placePicker;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:place_picker/place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo/AppConstants.dart' as Appconstants;

import '../HomeOrderAccount/Account/UI/ListItems/updateaddresses.dart';

class GoogleServiceProvider extends ChangeNotifier {

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

      locationData = await location.getLocation();
      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      print("Error fetching location: $e");
    }
  }


  showPlacePicker(context) async {
    try {
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
      print('llllllllllatitude${result.latLng?.latitude}');
      print('llllllllllongitude${result.latLng?.longitude}');
      print(_formattedAddress);
      notifyListeners();
      return _formattedAddress;
    } catch (e, stackTrace) {
      print("MAHESH ADD ADDRESS ERROR: $e");
      print("STACKTRACE: $stackTrace");
    }
  }

  showPlacePickerwithstoredloc(context, lat, lng, address, pincode) async {

    await getLocationAccess();

    print('MAHESH EDIT ADDRESS 1 : $lat $lng');
    print("Google API Key: $GoogleApiKey");
    print("Latitude: $lat, Longitude: $lng");

    try {

      locationResult?.latLng = LatLng(double.parse(lat), double.parse(lng));
      _formattedAddress = address ?? '';  // Handle potential nulls
      address = _formattedAddress;
      userAddressPinCode = pincode;
      print('Formatted Address: $_formattedAddress');
      print('Postal Code: $userAddressPinCode');
      notifyListeners();

      print("Navigating to PlacePicker...");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return placePicker.PlacePicker(
              GoogleApiKey,
              displayLocation: LatLng(double.parse(lat), double.parse(lng)),
            );
          },
        ),
      );
      return _formattedAddress;

    } catch (e, stackTrace) {
      print("MAHESH EDIT ADDRESS ERROR: $e");
      print("STACKTRACE: $stackTrace");
    }
  }

  // getAddressfromCordinates(value) async {
  //   List<geo.Placemark> placemarks =
  //   await geo.placemarkFromCoordinates(value.latitude!, value.longitude!);
  //   // print(jsonEncode(placemarks));
  //
  //   _formattedAddress =
  //   "${placemarks[0].street! + ',' + placemarks[0].name! + ',' + placemarks[0].thoroughfare! + ',' + placemarks[0].subLocality! + ',' + placemarks[0].locality! + ',' + placemarks[0].administrativeArea! + ',' + placemarks[0].country! + ',' + placemarks[0].postalCode!}";
  //   address = _formattedAddress;
  //   userAddressPinCode = placemarks[0].postalCode!;
  // }

  getUserPinCode() {
    print('PINCODE ${userAddressPinCode}');
    return userAddressPinCode;
  }

  getUserAddress() {
    print('ADDRESS ${_formattedAddress}');
    return _formattedAddress;
  }

  getAddressFromLatLng({@required context, double? lat, double? lng}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String _host = 'https://maps.google.com/maps/api/geocode/json';
        // final url = '$_host?key=""&language=en&latlng=$lat,$lng';
        final url = '$_host?key=$GoogleApiKey&language=en&latlng=$lat,$lng';
        print("i'm here URL ${url}");
        if (lng != null) {
          var response = await http.get(Uri.parse(url));
          print("i'm here status code ${response.statusCode}");
          if (response.statusCode == 200) {
            Map data = jsonDecode(response.body);
            if (data.length > 0 && data["results"].length > 0) {
              _formattedAddress = data["results"][0]["formatted_address"];
              address = _formattedAddress;

              List<dynamic> addressComponents = data["results"][0]["address_components"];
              String? postalCode;
              for (var component in addressComponents) {
                if (component["types"].contains("postal_code")) {
                  postalCode = component["long_name"];
                  break;
                }
              }
              userAddressPinCode = postalCode;
              print("response ==== $_formattedAddress");
              print('PINCODE ${data["results"][0]}');
              print('PINCODE ${postalCode}');
              print('PINCODE ${userAddressPinCode}');
              print("i'm here 4");
              notifyListeners();
              return _formattedAddress;
            } else {
              print("i'm here 5");
              return "failed";
            }
          } else
            print("i'm here 6");
            return "failed";
        } else
          print("i'm here 7");
          return "failed";
      }
    } on SocketException {
      showSnackBar(content: "No Internet Connection", context: context);
    } on Exception catch (e) {
      print(e);
    }
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

  getLatitude() {
    if (locationResult != null) {
      print("location result not null");
      print(locationResult?.latLng?.latitude);
      return locationResult?.latLng?.latitude;
    } else if (locationData != null) {
      print("locationData not null");
      return locationData!.latitude;
    }
  }

  getLongitude() {
    if (locationResult != null) {
      print("location result not null");
      print(locationResult?.latLng?.longitude);
      return locationResult?.latLng?.longitude;
    } else if (locationData != null) {
      print("locationData not null");
      return locationData!.longitude;
    }
  }
}