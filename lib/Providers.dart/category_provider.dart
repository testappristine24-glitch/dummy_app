import 'dart:convert';
import 'dart:io';

import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/AppConstants.dart' as Appconstants;
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Models/CategoryModel.dart';
import 'package:delivoo/Models/SubcategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  //CategoryModel? selectedcategory;
  CategoryModel? categories;

  SubcategoryModel? selectedsubcategory;
  SubcategoryModel? subcategories;
  int? selectedsubcategoryindex;
  bool _loading = true;
  bool get isLoading => _loading;

  Future<Null> getCategory({@required isload, shopid}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("shopid", shopid);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _loading = true;
        isload == true ? showLoading() : "";
        String requestJson = jsonEncode({
          "storeid": shopid.toString(),
          "Warehouseid": prefs.getString('warehouseid'),
          "StoreLocationId": prefs.getString('storelocationid'),
        });
        final response =
            await apiProvider.post(Appconstants.GET_CATEGORIES, requestJson);

        if (response != null && response["d"] != null) {
          categories = CategoryModel.fromJson(response);
        }
        //processresponsecat();
        notifyListeners();
        _loading = false;
        isload == true ? hideLoading() : "";
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    } on Exception catch (e) {
      hideLoading();
      print(e);
    }
  }

  setSelectedIndex(int index) {
    selectedsubcategoryindex = index;
    notifyListeners();
  }

  Future<String?> getSubcategory(catId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("catId $catId");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "storeid": prefs.getString("shopid"),
          "CatId": catId,
          "Warehouseid": prefs.getString('warehouseid'),
          "StoreLocationId": prefs.getString('storelocationid'),
        });

        final response =
            await apiProvider.post(Appconstants.GET_SUBCATEGORIES, requestJson);
        subcategories = SubcategoryModel.fromJson(response);
        print(subcategories.toString());
        //processresponsesubcat();
        hideLoading();
        notifyListeners();
        return "true";
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
      // showMessage('No Internet connection');
      return "false";

    } on Exception catch (e) {

      hideLoading();
      print(e);
      return "false";
    }
  }

  /* processresponsecat() async {
  setSelectedIndex(int index) {
    selectedsubcategoryindex = index;
    notifyListeners();
  }

  processresponsecat() async {
    CategoryModel c1 =
        CategoryModel(catId: 'c1', catImage: '', catTitle: 'fruits&vegetables');
    CategoryModel c2 =
        CategoryModel(catId: 'c2', catImage: '', catTitle: 'groceries');

    categories?.clear();
    categories?.add(c1);
    categories?.add(c2);
  }
 */
  /* processresponsesubcat() async {
    SubcategoryModel sc1 = SubcategoryModel(
        subcatId: 'sc1',
        subcatImage: 'images/veg/Vegetables/onion.png',
        subcatTitle: 'Exotic');
    SubcategoryModel sc2 = SubcategoryModel(
        subcatId: 'sc2',
        subcatImage: 'images/veg/Vegetables/onion.png',
        subcatTitle: 'leafy');

    subcategories!.clear();
    subcategories!.add(sc1);
    subcategories!.add(sc2);
  } */
}
