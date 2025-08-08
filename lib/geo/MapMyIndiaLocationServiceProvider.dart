import 'dart:convert';
import 'dart:io';
import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo/AppConstants.dart' as Appconstants;

class MapMyIndiaLocationServiceProvider extends ChangeNotifier {

  final ApiProvider apiProvider = ApiProvider();
  Location location = new Location();
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  bool? _serviceEnabled;
  bool _loading = true;

  LatLng? locationResult;
  var _timeCalculate;
  String storeDistance = "";
  var _formattedAddress;
  var userAddressPinCode;
  // Position? locationData;
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

  getUserPinCode() {
    return userAddressPinCode;
  }

  getUserAddress() {
    print('ADDRESS ${_formattedAddress}');
    return _formattedAddress;
  }

  getAddressFromLatLng({@required context, double? lat, double? lng}) async {

    try {
      var _currentLocation = LatLng(lat!, lng!);
      ReverseGeocodeResponse? result = await MapplsReverseGeocode(
          location: _currentLocation).callReverseGeocode();
      if(result != null) {
        print("PLACE -- ${result.results?[0].formattedAddress}");
        _formattedAddress = result.results?[0].formattedAddress;
        address = _formattedAddress;
        userAddressPinCode = result.results?[0].pincode;
        print("response ==== $_formattedAddress");
        print('PINCODE ${result.results?[0]}');

        print('PINCODE ${userAddressPinCode}');
        notifyListeners();
        return _formattedAddress;
      } else {
        return "failed";
      }
    } catch (e) {
      PlatformException map = e as PlatformException;
      print(map.code);
      return "failed";
    }
  }

  checkStoreFromLatLng(
      {@required context, double? lat, double? lng, bool? load}) async {
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
        final response = await apiProvider.post(
            Appconstants.GET_StoreCheckList, requestJson);
        print('---------------getotp');

        storeStatus = response["d"];
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
      print(locationResult?.latitude);
      return locationResult?.latitude;
    } else if (locationData != null) {
      print("locationData not null");
      return locationData!.latitude;
    }
  }

  getLongitude() {
    if (locationResult != null) {
      print("location result not null");
      print(locationResult?.longitude);
      return locationResult?.longitude;
    } else if (locationData != null) {
      print("locationData not null");
      return locationData!.longitude;
    }
  }
}