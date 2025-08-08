import 'dart:convert';
import 'dart:io';

import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Models/BannerModel.dart';
import 'package:delivoo/Models/FlashImgModel.dart';
import 'package:flutter/material.dart';
import 'package:delivoo/AppConstants.dart' as Appconstants;
import 'package:shared_preferences/shared_preferences.dart';

class Bannerprovider extends ChangeNotifier {

  final ApiProvider apiProvider = ApiProvider();

  BannerModel? banners;
  BannerModel? selectedbanner;
  FlashImg? flashImg;
  bool? isload = true;
  bool _loading = true;
  bool get isLoading => _loading;

  notify() {
    notifyListeners();
  }

  getbanners({@required isLoad}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _loading = true;
        isLoad == true ? showLoading() : "";
        String requestJson =
            jsonEncode({"storeid": prefs.getString("shopid"), "CatId": "1"});
        final response =
            await apiProvider.post(Appconstants.GET_BANNERS, requestJson);
        print(response.toString());
        if (response != null && response["d"] != null) {
          banners = BannerModel.fromJson(response);
        }

        // processresponsebanner();

        _loading = false;
        isLoad == true ? hideLoading() : "";
        notifyListeners();
      }
      //return null;
    } on Exception catch (e) {
      _loading = false;
      isload == true ? hideLoading() : "";
      print(e);
    }
  }

  popupbanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.getString("shopid")
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "shopid": prefs.getString("shopid"),
          "Warehouseid": prefs.getString("warehouseid"),
          "flashimg": "1"
        });
        final response =
            await apiProvider.post(Appconstants.FLASH_IMG, requestJson);
        print(jsonEncode(response["d"].toString()));
        if (response != null && response['d'] != null) {
          flashImg = FlashImg.fromJson(response);
        }
        //processresponsebanner();
        notifyListeners();
      }
      //return null;
    } on Exception catch (e) {
      print(e);
    }
  }

  /* processresponsebanner() async {
    BannerModel b1 = BannerModel(bannerId: 'b1', bannerImage: '');
    BannerModel b2 = BannerModel(bannerId: 'b2', bannerImage: '');

    banners.clear();
    banners.add(b1);
    banners.add(b2);
    print(banners[0].bannerId);
  } */
}
