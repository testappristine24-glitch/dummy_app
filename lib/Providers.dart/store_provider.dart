// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Models/StoreModel.dart' as Storemodel;
import 'package:delivoo/AppConstants.dart' as Appconstants;
import 'package:delivoo/Models/TimeslotModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/FeedbackModel.dart';
import '../Models/FeedbacksModel.dart';
import '../Models/complimentaryModel.dart' as complimenat;

class StoreProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  Storemodel.StoreModel? stores;
  Storemodel.D? selectedstore;
  Storemodel.StoreModel? allstores;
  TimeslotModel? timeslots;
  D? selectedtimeslot;
  complimenat.ComplimentaryModel? complimentary;
  CheckBoxModel? feedbacks;
  CheckBoxsModel? feedback;

  int? currentindex = 0;
  bool? storeselected = false;
  int? selectedBarIndex = 0;
  bool? fromallstoresselected = false;
  bool _loading = true;

  bool get isLoading => _loading;
  bool? isloading = false;

  bool questionType = false;
  bool businessModel = false;
  // int currentIndex = 2;
  String? mno;
  get getmno => mno;
  var rating = 0;
  double Rating = 0.0;

  refresh() {
    notifyListeners();
  }

  updateEmoji(value) {
    rating = value;
    notifyListeners();
  }

  onTapped(int index) {
    currentindex = index;
    selectedBarIndex = index;
    notifyListeners();
  }

  selectstore(String warehouseid) async {
    Storemodel.D? store;
    if (stores?.d?.length == 1) {
      store = stores?.d?[0];
      //storeselected = false;
      //notifyListeners();
    } else if (stores!.d!.length > 1) {
      store = stores?.d?.firstWhere((e) => e.wareHouseId == warehouseid);
      //storeselected = true;
      //notifyListeners();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (fromallstoresselected == true) {
      print('allstores');
      store = allstores?.d?.firstWhere((e) => e.wareHouseId == warehouseid);
    }
    prefs.setString("shopid", store != null ? store.shopid! : "");
    prefs.setString("warehouseid", store != null ? store.wareHouseId! : "");
    prefs.setString(
        "storelocationid", store != null ? store.storeLocationId! : "");
    selectedstore = await store;
    print('aaaaaaaa${selectedstore?.wareHouseId}');

    print("store warehouseid name ${prefs.getString("warehouseid")}");
    print("store name ${selectedstore?.shopName}");
    notifyListeners();
    return selectedstore?.wareHouseId;
  }

  selecttimeslot(timeslotid) {
    selectedtimeslot = timeslots?.d?.firstWhere((e) => e.slotid == timeslotid);
    notifyListeners();
  }

  getstoredetailsbyaddressid({addressid, loading}) async {
    print("addres iddd $addressid");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _loading = true;
        loading == true ? showLoading() : "";
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "Action": "1",
          "latitude": "",
          "longitude": "",
          "membershipno": prefs.getString("com_id"),
          "adid": addressid != null ? addressid : ""
        });
        print("GET STORE $requestJson");
        final response =
            await apiProvider.post(Appconstants.GET_STORES, requestJson);
        if (response != null && response['d'] != null) {
          stores?.d = [];
          stores = await Storemodel.StoreModel.fromJson(response);
        } else {
          stores?.d = [];
        }

        if (stores?.d?.length == 1) {
          storeselected = true;
          _loading = false;
          loading == true ? hideLoading() : "";
          notifyListeners();
        } else {
          storeselected = false;
          _loading = false;
          loading == true ? hideLoading() : "";
          notifyListeners();
        }
        print('---------------getstoredetailsbyaddressid');

        //await processResponse();
        notifyListeners();
      }
    } on SocketException {
      noInternet();
      //showMessage('No internet connection');
    }
  }

  getallstores({@required isLoad}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _loading = true;
        isLoad == true ? showLoading() : "";
        log("comId" + prefs.getString("com_id").toString());
        log("warehouseid" + prefs.getString("warehouseid").toString());
        log("storelocationid" + prefs.getString("storelocationid").toString());
        String requestJson = jsonEncode({
          "Action": "2",
          "latitude": "",
          "longitude": "",
          "membershipno": prefs.getString("com_id"),
          "adid": "",
          "shopid": "",
          "Warehouseid": prefs.getString("warehouseid") ?? "",
          "StoreLocationId": ""
        });
        final response =
            await apiProvider.post(Appconstants.SelectStore, requestJson);
        if (response != null && response["d"] != null) {
          allstores = await Storemodel.StoreModel.fromJson(response);

          print('---------------getallstores');
        }
      } else {
        stores?.d = [];
      }

      if (stores?.d?.length == 1) {
        storeselected = true;
        _loading = false;
        isLoad == true ? hideLoading() : "";
        notifyListeners();
      } else {
        storeselected = false;
        _loading = false;
        isLoad == true ? hideLoading() : "";

        notifyListeners();
      }
    } on SocketException {
      noInternet();
      //showMessage('No internet connection');
    }
  }

  getThestore({
    @required isLoad,
  }) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _loading = true;
        isLoad == true ? showLoading() : "";
        log("comId" + prefs.getString("com_id").toString());
        log("warehouseid" + prefs.getString("warehouseid").toString());
        log("storelocationid" + prefs.getString("storelocationid").toString());
        String requestJson = jsonEncode({
          "Action": "3",
          "latitude": "",
          "longitude": "",
          "membershipno": prefs.getString("com_id"),
          "adid": "",
          "shopid": "",
          "Warehouseid": prefs.getString("warehouseid") ?? "",
          "StoreLocationId": ""
        });
        final response =
            await apiProvider.post(Appconstants.SelectStore, requestJson);
        if (response != null && response["d"] != null) {
          stores = Storemodel.StoreModel.fromJson(response);
          print('---------------getTheStore');
        }
      } else {
        stores?.d = [];
      }

      if (stores?.d?.length == 1) {
        storeselected = true;
        _loading = false;
        isLoad == true ? hideLoading() : "";
        notifyListeners();
      } else {
        storeselected = false;
        _loading = false;
        isLoad == true ? hideLoading() : "";

        notifyListeners();
      }
    } on SocketException {
      noInternet();
      //showMessage('No internet connection');
    }
  }

  selectTheStore({@required isLoad, shopId, warehouseId, storeLocation}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _loading = true;
        isLoad == true ? showLoading() : "";
        log("comId" + prefs.getString("com_id").toString());
        log("shopId" + shopId);
        log("warehouse ${warehouseId}");
        log("storelocation ${storeLocation}");
        String requestJson = jsonEncode({
          "Action": "2",
          "latitude": "",
          "longitude": "",
          "membershipno": prefs.getString("com_id"),
          "adid": "",
          "shopid": shopId ?? "",
          "Warehouseid": warehouseId ?? "",
          "StoreLocationId": storeLocation ?? ""
        });
        final response =
            await apiProvider.post(Appconstants.SelectStore, requestJson);
        if (response != null && response["d"] != null) {
          allstores = Storemodel.StoreModel.fromJson(response);
          print('---------------getallstores');
        }

        notifyListeners();
        _loading = false;
        isLoad == true ? hideLoading() : "";
      }
    } on SocketException {
      noInternet();
    }
  }

  getstoredetailsbypincode(String pincode) async {
    /*  String requestJson = jsonEncode({"pincode": pincode});
    final response =
        await apiProvider.post(Appconstants.LOAD_STATE, requestJson);
        print('---------------getstoredetailsbypincode');
    print(response["d"]); */
    //await processResponse();
    notifyListeners();
  }

  gettimeslots() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('----mem------${prefs.getString("com_id")}');
        String requestJson = jsonEncode({
          "membershipno": prefs.getString("com_id"),
          "shopid": prefs.getString("shopid"),
          "Warehouseid": prefs.getString('warehouseid'),
          "StoreLocationId": prefs.getString('storelocationid'),
        });
        print("$requestJson");
        final response =
            await apiProvider.post(Appconstants.GET_TIMESLOTS, requestJson);
        timeslots = TimeslotModel.fromJson(response);
        print('---------------gettimeslots');

        //await processResponse();
        notifyListeners();
      }
    } on SocketException {
      noInternet();
      //showMessage('No internet connection');
    }
  }

  checkshoplocation() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        showLoading();
        String requestJson = jsonEncode({
          "shopid": prefs.getString("shopid"),
          "membershipno": prefs.getString("com_id"),
          "Warehouseid": prefs.getString("warehouseid"),
          "StoreLocationId": prefs.getString("storelocationid")
        });
        final response = await apiProvider.post(
            Appconstants.CHECK_SHOP_LOCATION, requestJson);
        // allstores = Storemodel.StoreModel.fromJson(response);
        print('---------------checkshoplocation');
        print('${response["d"]}-----&----${prefs.getString("shopid")}');
        notifyListeners();
        hideLoading();
        if (response["d"] != prefs.getString("shopid") ||
            response["d"] == null ||
            response["d"] == '') {
          return '1';
        } else {
          return '0';
        }
      }
    } on SocketException {
      noInternet();
      //showMessage('No internet connection');
    }
  }

  getComplimentary() async {
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('----mem------${prefs.getString("com_id")}');
        String requestJson = jsonEncode({
          "borderid": prefs.getString('orderid'),
          "mobileno": prefs.getString('com_id'),
          "membershipno": prefs.getString("com_id"),
          "company_id": prefs.getString("shopid"),
          "Warehouseid": prefs.getString('warehouseid'),
        });
        final response =
            await apiProvider.post(Appconstants.GetComplimentary, requestJson);
        if (response != null || response.d != null) {
          complimentary = complimenat.ComplimentaryModel.fromJson(response);
        }
        notifyListeners();
      }
      hideLoading();
    } on SocketException {
      hideLoading();
      noInternet();
      // showMessage('No internet connection');
    }
  }

  getfeedbackquestion() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      showLoading();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson =
            jsonEncode({"Questiontype": "0", "Businessmodel": "2"});
        final response = await apiProvider.post(
            Appconstants.GetFeedbackQuestion, requestJson);
        feedbacks = CheckBoxModel.fromJson(response);
        print('$response---------------getfeedbackquestion');
        notifyListeners();
      }
      hideLoading();
    } on SocketException {
      noInternet();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  getfeedbackquestions() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson =
            jsonEncode({"Questiontype": "1", "Businessmodel": "2"});
        final response = await apiProvider.post(
            Appconstants.GetFeedbackQuestion, requestJson);
        feedback = CheckBoxsModel.fromJson(response);
        print('$response---------------getfeedbackquestions');
        notifyListeners();
      }
    } on SocketException {
      noInternet();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  submitfeedback(qid, chckStatus, questiontype, orderId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      showLoading();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "QId": qid,
          "membershipno": prefs.getString("com_id"),
          "orderid": orderId,
          "Mobileno": prefs.getString('mob_no'),
          "Questiontype": questiontype,
          "chkstatus": chckStatus,
          "Businessmodel": "2"
        });
        final response =
            await apiProvider.post(Appconstants.SubmitFeedback, requestJson);
        if (response != null || response.d != null)
          print('$response---------------submitfeedback');
        print('----QId------${qid}');

        print('----membershipno------${prefs.getString("com_id")}');
        print('----orderid------${orderId}');
        print('----Mobileno------${prefs.getString('mob_no')}');
        print('----Questiontype------${questiontype}');
        print('----chkstatus------${chckStatus}');
        notifyListeners();
      }
      hideLoading();
    } on SocketException {
      noInternet();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  submitratings(rating, orderId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      showLoading();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "orderid": orderId,
          "membershipno": prefs.getString("com_id"),
          "Mobileno": prefs.getString('mob_no'),
          "Ratings": rating,
          "Businessmodel": "2"
        });
        final response =
            await apiProvider.post(Appconstants.SubmitRatings, requestJson);
        if (response != null || response.d != null)
          print('$response---------------submitratings');
        print('----Ratings------${rating}');
        print('----orderid------${orderId}');
        print('----Mobileno------${prefs.getString('mob_no')}');
        notifyListeners();
      }
      hideLoading();
    } on SocketException {
      noInternet();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  finalsubmitratings(orderId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      showLoading();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "orderid": orderId,
          "membershipno": prefs.getString("com_id"),
          "Mobileno": prefs.getString('mob_no'),
          "Businessmodel": "2"
        });
        final response = await apiProvider.post(
            Appconstants.FinalSubmitRatings, requestJson);
        if (response != null || response.d != null)
          print('$response---------------finalsubmitratings');
        print('----membershipno------${prefs.getString("com_id")}');
        print('----orderid------${orderId}');
        print('----Mobileno------${prefs.getString('mob_no')}');
        notifyListeners();
      }
      hideLoading();
    } on SocketException {
      noInternet();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  removeComplimentary() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      showLoading();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "orderid": prefs.getString('orderid'),
          "company_id": prefs.getString("com_id"),
          "Warehouseid": prefs.getString('warehouseid'),
          "MobileNo": prefs.getString('mob_no'),
          "reason": ""
        });
        final response = await apiProvider.post(
            Appconstants.RemoveComplimentary, requestJson);
      }
      hideLoading();
      notifyListeners();
    } on SocketException {
      noInternet();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  /* processResponse() async {
    StoreModel s1 = StoreModel(
        storeId: '1',
        name: 'supermkt1',
        address: 'aundh',
        contactNo: '1234567890',
        timing: '6-9',
        image: '');

    StoreModel s2 = StoreModel(
        storeId: '2',
        name: 'supermkt2',
        address: 'baner',
        contactNo: '1234567899',
        timing: '7-9',
        image: '');
    stores.clear();
    stores.add(s1);
    stores.add(s2);
  } */
}
