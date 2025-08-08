// ignore_for_file: unused_local_variable, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Models/AddressModel.dart';
import 'package:delivoo/main.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo/AppConstants.dart' as Appconstants;

class Addressprovider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  AddressModel? addresses;

  D? selectedAddress;

  String? selectedPincode;
  double? lat;
  double? long;
  bool addrediting = false;
  bool addnewAdd = false;
  int addressindex = 0;
  String? addresstype = 'Home';
  bool? changelocation = false;
  bool _loading = true;
  bool get isLoading => _loading;
  bool showLocationDialog = true;

  setLocationDialog(bool? value) async {
    showLocationDialog = value!;
    notifyListeners();
  }

  changecolor() {
    notifyListeners();
  }

  getaddresses({@required isload}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userid');
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "Action": "5",
          "membershipno": prefs.getString("com_id"),
          "Address": "",
          "adid": "",
          "address1": "",
          "address2": "",
          "title": "",
          "latitude": "",
          "longitude": "",
          "pincode": "",
          "addstatus": "1",
          "LocationId": "",
          "Cityid": ""
        });
        print("GET ADDRESS -> $requestJson");

        _loading = true;
        isload == true ? showLoading() : "";
        final response =
            await apiProvider.post(Appconstants.GET_ADDRESSES, requestJson);
        if (response != null && response["d"] != null) {
          print(jsonEncode(response["d"].toString()));
          addresses = AddressModel.fromJson(response);
        }
        _loading = false;
        isload == true ? hideLoading() : "";
        if (response == null) {
          _loading = false;
          isload == true ? hideLoading() : "";
          notifyListeners();
          return;
        }

        bool? saddr = false;
        for (int i = 0; i < addresses!.d!.length; i++) {
          if (addresses?.d?[i].adstatus == '1') {
            saddr = true;
          }
        }
        print('66666666666666$saddr');
        if (saddr == true) {
          selectedAddress = addresses?.d?.firstWhere((e) => e.adstatus == "1");
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      showSnackBar(
          content: "No Internet Connection",
          context: navigatorKey.currentState!.context);
      // showMessage('No Internet connection');
      print(e);
    }
  }

  updateNewLocation(
      {addr1,
      addr2,
      address,
      title,
      lat,
      long,
      pincode,
      Action,
      locationId,
      addId, cityId}) async {
    try {
      log(Action.toString());
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": Action != null ? Action.toString() : "2",
          "membershipno": prefs.getString("com_id"),
          "Address": address,
          "adid": addId != null ? addId : addresses?.d?[addressindex].addressId,
          "address1": addr1,
          "address2": addr2,
          "title": title,
          "latitude": lat,
          "longitude": long,
          "pincode": pincode,
          "addstatus": "1",
          "LocationId": "",
          "Cityid": cityId
        });
        print("UPDATE NEW LOCATION -> $requestJson");

        final response =
            await apiProvider.post(Appconstants.GET_ADDRESSES, requestJson);
        if (response != null && response["d"] != null) {
          addresses = AddressModel.fromJson(response);
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();

      print(e);
    }
  }

  updateaddress({
    addr1,
    addr2,
    address,
    title,
    lat,
    long,
    pincode,
    Action,
    locationId,
    cityId
  }) async {
    print("Action $Action");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": Action != null ? Action.toString() : "2",
          "membershipno": prefs.getString("com_id"),
          "Address": address,
          "adid": addresses?.d?[addressindex].addressId,
          "address1": addr1,
          "address2": addr2,
          "title": title,
          "latitude": lat,
          "longitude": long,
          "pincode": pincode,
          "addstatus": "1",
          "LocationId": locationId != null
              ? locationId
              : prefs.getString('LocationId').toString(),
          "Cityid": cityId
        });
        print("UPDATE ADDRESS -> $requestJson");
        print("$requestJson");
        final response =
            await apiProvider.post(Appconstants.GET_ADDRESSES, requestJson);
        if (response != null && response["d"] != null) {
          addresses = AddressModel.fromJson(response);
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    }
  }

  updatelocation(addr1, addr2, address, title, lat, long, pincode, adid,
      LocationID, cityId) async {
    print("address idddddd ${adid}");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "2",
          "membershipno": prefs.getString("com_id"),
          "Address": address,
          "adid": adid,
          "address1": addr1,
          "address2": addr2,
          "title": title,
          "latitude": lat,
          "longitude": long,
          "pincode": pincode,
          "addstatus": "1",
          "LocationId":
              LocationID.toString() != null ? LocationID.toString() : "",
          "Cityid": cityId
        });
        print("UPDATE LOCATION -> $requestJson");
        print('wwwwwwwwwwwwwww');
        final response =
            await apiProvider.post(Appconstants.GET_ADDRESSES, requestJson);
        addresses = AddressModel.fromJson(response);
        print("uuuuuuuuuuuuuuuuu");
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    }
  }

  getaddressid(String addresstype) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var address =
            addresses?.d?.firstWhere((e) => e.addressId == addresstype);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "6",
          "membershipno": prefs.getString("com_id"),
          "Address": "",
          "adid": address?.addressId,
          "address1": "",
          "address2": "",
          "title": "",
          "latitude": "",
          "longitude": "",
          "pincode": "",
          "addstatus": "1",
          "LocationId": "",
          "Cityid": ""
        });
        print("GET -> $requestJson");
        final response =
            await apiProvider.post(Appconstants.GET_ADDRESSES, requestJson);
        addresses = AddressModel.fromJson(response);
        selectedAddress = address!;
        print('aaaaaaaaaaaa${selectedAddress?.title}');
        prefs.setString("addid", address.addressId!);
        notifyListeners();
        return address.addressId;
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    }
  }

  addaddress(String addr1, String addr2, String type, lat, long, address, pincode, locationId, cityId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "1",
          "membershipno": prefs.getString("com_id"),
          "Address": address,
          "adid": "",
          "address1": addr1,
          "address2": addr2,
          "title": type,
          "latitude": lat,
          "longitude": long,
          "pincode": pincode,
          "addstatus": "1",
          "LocationId": locationId != null || locationId != ""
              ? locationId
              : prefs.getString('LocationId'),
          "Cityid": cityId
        });
        print("ADD ADDRESS");
        print("$requestJson");
        final response =
            await apiProvider.post(Appconstants.GET_ADDRESSES, requestJson);
        print("$response");
        addresses = AddressModel.fromJson(response);
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    }
  }

  removeaddress(index) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "3",
          "membershipno": prefs.getString("com_id"),
          "Address": "",
          "adid": addresses?.d?[index].addressId,
          "address1": "",
          "address2": "",
          "title": "",
          "latitude": "",
          "longitude": "",
          "pincode": "",
          "addstatus": "",
          "LocationId": "", "Cityid": ""
        });
        print("REMOVE -> $requestJson");
        final response =
            await apiProvider.post(Appconstants.GET_ADDRESSES, requestJson);
        addresses = AddressModel.fromJson(response);

        bool? saddr = false;
        for (int i = 0; i < addresses!.d!.length; i++) {
          if (addresses?.d?[i].adstatus == '1') {
            saddr = true;
          }
        }
        print('66666666666666$saddr');
        if (saddr == true) {
          selectedAddress = addresses?.d?.firstWhere((e) => e.adstatus == "1");
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }
}
