import 'dart:convert';
import 'dart:io';

import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Models/CartModel.dart';
import 'package:delivoo/Models/CartTotalModel.dart';
import 'package:delivoo/Models/ProductModel.dart' as Product;
import 'package:delivoo/Models/searchModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivoo/AppConstants.dart' as Appconstants;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/load_coupon_model.dart';

class ProductProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  Product.ProductModel? products;
  Product.D? selectedProducts;
  CartTotalModel? cartTotal;
  List<SearchModel> search = [];
  LoadCouponsModel? loadCouponList;

  CartModel? cartitems;
  int cartindex = 0;
  int index1 = 0;
  int? productIndex = 0;
  int numberOfItems = 0;
  int productDetailsIndex = 0;
  List<String> items = [];
  bool? isfirstproduct = false;
  bool? instorepickup = false;
  var tabValue = 0;

  String? orderid = '';
  int tabIndex = 0;
  // bool? isloading = false;

  getProductIndex(product, index) {
    selectedProducts = product;
    productIndex = index;
    notifyListeners();
  }

  getTabIndex(index) async {
    tabIndex = index;
    notifyListeners();
  }

  mapcartwithproducts() async {
    if (cartitems == null || cartitems?.d?.length == 0) {
      for (var j = 0; j < products!.d!.length; j++) {
        for (var k = 0; k < products!.d![j].productDetails!.length; k++) {
          products!.d![j].productDetails![k].productQty = 0;
          products!.d![j].totproductQty = 0;
        }
      }
    } else {
      for (var i = 0; i < cartitems!.d!.length; i++) {
        int index = products!.d!.indexWhere(
            (element) => element.productName == cartitems?.d?[i].productName);
        if (index >= 0) {
          products?.d?[index].totproductQty = 0;
        }
      }
      for (var i = 0; i < cartitems!.d!.length; i++) {
        int index = products!.d!.indexWhere(
            (element) => element.productName == cartitems?.d?[i].productName);

        if (index >= 0) {
          int productIndex = await products!.d![index].productDetails!
              .indexWhere((element) =>
                  element.productCode == cartitems?.d?[i].productCode);
          products!.d![index].productDetails![productIndex].productQty =
              await cartitems!.d?[i].productQty;

          products!.d![index].totproductQty =
              cartitems!.d![i].productQty! + products!.d![index].totproductQty!;
        }
      }
    }
    notifyListeners();
  }

  getProductsByCategory({sectiontId, searchtxt, catId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("sectionID: $sectiontId");
    print("catId: $catId");
    print("shopId ${prefs.getString("shopid")}");
    print("orderId:${prefs.getString('orderid')}");
    print("WareHouseId ${prefs.getString('warehouseid')}");
    print("storeLocation ${prefs.getString('storelocationid')}");
    print("membershipNo ${prefs.getString('com_id')}");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "subtypeid": '$sectiontId',
          "sku_cat_id": catId,
          "FlagAll": "1",
          "SearchText": "$searchtxt",
          "offset": "0",
          "shopid": prefs.getString("shopid"),
          "City_Id": "2",
          "orderid": prefs.getString('orderid'),
          "Warehouseid": prefs.getString('warehouseid'),
          "StoreLocationId": prefs.getString('storelocationid'),
          "membershipNo": prefs.getString('com_id')
        });
        final response =
            await apiProvider.post(Appconstants.GET_PRODUCTS, requestJson);

        if (response["d"] != null) {
          products = Product.ProductModel.fromJson(response);
          if (searchtxt == '' || searchtxt == null) {
            items = List.generate(products!.d!.length,
                (index) => products!.d![index].productName.toString());
          }
          hideLoading();
        } else {
          products?.d = [];
          hideLoading();
          // showMessage('No Products Found');
          // await processResponse();
        }
        notifyListeners();
        return products?.d;
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    } on Exception catch (e) {
      hideLoading();
      print(e);
    }
  }

  increaseCount({index, productNewIndex}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (prefs.getString('orderid') == '' ||
            prefs.getString('orderid') == null) {
          showLoading();
          isfirstproduct = true;
        }
        products?.d?[index].isloading = true;
        products?.d?[index].productDetails![productNewIndex].isloading = true;
        notifyListeners();

        // int productIndex = products!.d![productNewIndex].productDetailsIndex;
        if (cartitems?.d?.length == null) {
          orderid = '';
        }
        prefs.setString('orderid', orderid!);
        if (products!.d![index].productDetails![productNewIndex].orderLimt !=
            0) {
          if (products!.d![index].productDetails![productNewIndex].productQty! <
              products!.d![index].productDetails![productNewIndex].orderLimt!) {
            products!.d![index].productDetails![productNewIndex].productQty =
                products!.d![index].productDetails![productNewIndex]
                        .productQty! +
                    1;
            products!.d![index].totproductQty =
                products!.d![index].totproductQty! + 1;
            String requestJson = jsonEncode({
              "productcode":
                  "${products!.d![index].productDetails![productNewIndex].productCode}",
              "qty": products!
                  .d![index].productDetails![productNewIndex].productQty,
              "orderid": prefs.getString('orderid'),
              "shopid": prefs.getString("shopid"),
              "membershipno": prefs.getString('com_id'),
              "Warehouseid": prefs.getString('warehouseid'),
              "StoreLocationId": prefs.getString('storelocationid'),
            });
            final response =
                await apiProvider.post(Appconstants.ADD_PRODUCT, requestJson);
            cartitems = CartModel.fromJson(response);
            orderid = cartitems?.d?[0].orderid!;
            prefs.setString('orderid', orderid!);
            print('order id: $orderid');
          } else {
            print('object');
            Fluttertoast.showToast(
                msg: "Max limit reached",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          products!.d![index].productDetails![productNewIndex].productQty =
              products!.d![index].productDetails![productNewIndex].productQty! +
                  1;
          products!.d![index].totproductQty =
              products!.d![index].totproductQty! + 1;
          String requestJson = jsonEncode({
            "productcode":
                "${products!.d![index].productDetails![productNewIndex].productCode}",
            "qty":
                products!.d![index].productDetails![productNewIndex].productQty,
            "orderid": prefs.getString('orderid'),
            "shopid": prefs.getString("shopid"),
            "membershipno": prefs.getString('com_id'),
            "Warehouseid": prefs.getString('warehouseid'),
            "StoreLocationId": prefs.getString('storelocationid'),
          });
          final response =
              await apiProvider.post(Appconstants.ADD_PRODUCT, requestJson);
          cartitems = CartModel.fromJson(response);
          orderid = cartitems?.d?[0].orderid!;
          prefs.setString('orderid', orderid!);
          /*  if (products!.d![index].productDetails![productIndex].productQty! == 1) {
        addtocart(index);
      } else {
        updateCart(index);
      } */
        }
        getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        products?.d?[index].isloading = false;
        products?.d?[index].productDetails![productNewIndex].isloading = false;
        if (isfirstproduct == true) {
          hideLoading();
          isfirstproduct = false;
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      print("bbbbbbbbbbbbbbbbb");
      products?.d?[index].isloading = false;
      products?.d?[index].productDetails![productNewIndex].isloading = false;
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  increaseCountincart(cartindex) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        cartitems!.d?[cartindex].isloading = true;
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (cartitems!.d?[cartindex].maxcount != 0) {
          if (cartitems!.d![cartindex].productQty! <
              cartitems!.d![cartindex].maxcount!) {
            cartitems!.d?[cartindex].productQty =
                cartitems!.d![cartindex].productQty! + 1;
            String requestJson = jsonEncode({
              "productcode": "${cartitems!.d?[cartindex].productCode}",
              "qty": cartitems!.d![cartindex].productQty,
              "orderid": prefs.getString('orderid'),
              "shopid": prefs.getString("shopid"),
              "membershipno": prefs.getString('com_id'),
              "Warehouseid": prefs.getString('warehouseid'),
              "StoreLocationId": prefs.getString('storelocationid'),
            });
            final response =
                await apiProvider.post(Appconstants.ADD_PRODUCT, requestJson);
            cartitems = CartModel.fromJson(response);
            print(cartitems?.d?[0].productName);
            orderid = cartitems?.d?[0].orderid!;
            prefs.setString('orderid', orderid!);
            /* products!.d![index].productDetails![productIndex].productQty =
            cartitems!.d![cartindex].productQty; */
          }
        } else {
          cartitems!.d![cartindex].productQty =
              cartitems!.d![cartindex].productQty! + 1;
          String requestJson = jsonEncode({
            "productcode": "${cartitems!.d?[cartindex].productCode}",
            "qty": cartitems!.d![cartindex].productQty,
            "orderid": prefs.getString('orderid'),
            "shopid": prefs.getString("shopid"),
            "membershipno": prefs.getString('com_id'),
            "Warehouseid": prefs.getString('warehouseid'),
            "StoreLocationId": prefs.getString('storelocationid'),
          });
          print(requestJson);
          final response =
              await apiProvider.post(Appconstants.ADD_PRODUCT, requestJson);
          print(
              'aaaaaaaaaaa${response["d"][cartindex]["productWeight"]}-------');
          cartitems = CartModel.fromJson(response);
          print('kdfdklkdcl${cartitems?.d?[cartindex].productWeight}');
          orderid = cartitems?.d?[0].orderid!;
          prefs.setString('orderid', orderid!);
          // products!.d![index].productDetails![productIndex].productQty =
          //     cartitems!.d![cartindex].productQty;

        }
        if (products != null) {
          mapcartwithproducts();
        }
        getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
          cartitems!.d?[i].isloading = false;
        }
        // cartitems!.d?[cartindex].isloading = false;
        notifyListeners();
      }
    } on SocketException catch (e) {
      print("bbbbbbbbbbbbbbbbb");
      products?.d?[cartindex].isloading = false;
      noInternet();
      //showMessage('No Internet connection');
      print(e);
    }
  }

  decreaseCount({index, productNewIndex}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        products?.d?[index].isloading = true;
        products?.d?[index].productDetails![productNewIndex].isloading = true;
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // int productIndex = products!.d![productNewIndex].productDetailsIndex;

        cartindex = cartitems!.d!.indexWhere((element) =>
            element.productName == products!.d![index].productName);
        if (products!.d![index].productDetails![productNewIndex].productQty! >
            0) {
          products!.d![index].productDetails![productNewIndex].productQty =
              products!.d![index].productDetails![productNewIndex].productQty! -
                  1;
          products!.d![index].totproductQty =
              products!.d![index].totproductQty! - 1;
        }
        String requestJson = jsonEncode({
          "productcode":
              "${products!.d![index].productDetails![productNewIndex].productCode}",
          "qty":
              products!.d![index].productDetails![productNewIndex].productQty,
          "orderid": prefs.getString('orderid'),
          "shopid": prefs.getString("shopid"),
          "membershipno": prefs.getString('com_id'),
          "Warehouseid": prefs.getString('warehouseid'),
          "StoreLocationId": prefs.getString('storelocationid'),
        });
        final response =
            await apiProvider.post(Appconstants.ADD_PRODUCT, requestJson);
        cartitems = CartModel.fromJson(response);
        orderid = cartitems?.d != null && cartitems!.d!.isNotEmpty
            ? (cartitems?.d?[0].orderid)
            : '';
        prefs.setString('orderid', orderid!);
        /* if (products!.d![index].productDetails![productIndex].productQty! == 0) {
      removefromcart(cartindex);
    } else {
      updateCart(index);
    } */
        getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        products?.d?[index].isloading = false;
        products?.d?[index].productDetails![productNewIndex].isloading = false;
        notifyListeners();
      }
    } on SocketException catch (e) {
      print("bbbbbbbbbbbbbbbbb");
      products?.d?[index].isloading = false;
      products?.d?[index].productDetails![productNewIndex].isloading = false;
      noInternet();
      //showMessage('No Internet connection');
      print(e);
    }
  }

  decreaseCountincart(cartindex) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        cartitems!.d?[cartindex].isloading = true;
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (cartitems!.d![cartindex].productQty! > 0) {
          cartitems!.d![cartindex].productQty =
              cartitems!.d![cartindex].productQty! - 1;
          if (products != null) {
            mapcartwithproducts();
          }
          String requestJson = jsonEncode({
            "productcode": "${cartitems!.d?[cartindex].productCode}",
            "qty": cartitems!.d![cartindex].productQty,
            "orderid": prefs.getString('orderid'),
            "shopid": prefs.getString("shopid"),
            "membershipno": prefs.getString('com_id'),
            "Warehouseid": prefs.getString('warehouseid'),
            "StoreLocationId": prefs.getString('storelocationid'),
          });
          final response =
              await apiProvider.post(Appconstants.ADD_PRODUCT, requestJson);
          cartitems = CartModel.fromJson(response);
          orderid = cartitems?.d != null && cartitems!.d!.isNotEmpty
              ? (cartitems?.d?[0].orderid)
              : '';
          prefs.setString('orderid', orderid!);
        }

        notifyListeners();
        if (products != null) {
          mapcartwithproducts();
        }
        getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
          cartitems!.d?[i].isloading = false;
        }
        // cartitems!.d?[cartindex].isloading = false;
        notifyListeners();
      }
    } on SocketException catch (e) {
      print("bbbbbbbbbbbbbbbbb");
      products?.d?[cartindex].isloading = false;
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  selectedItemWeight(widgetIndex, index) async {
    products!.d![widgetIndex].productDetailsIndex = index;
    notifyListeners();
  }

  selectedDescItemWeight(productIndex, index) async {
    productIndex.productDetailsIndex = index;
    notifyListeners();
  }

  addtocart(index) {
    products!.d![index].productDetailsIndex;
  }

  updateCart(index) {
    int productIndex = products!.d![index].productDetailsIndex;

    cartindex = cartitems!.d!.indexWhere((element) =>
        element.productCode ==
        products!.d![index].productDetails![productIndex].productCode);

    cartitems!.d![cartindex].productQty =
        products!.d![index].productDetails![productIndex].productQty;

    cartitems!.d![cartindex].productImage =
        products!.d![index].productDetails![productIndex].productimage;

    notifyListeners();
  }

  removefromcart(cartindex) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "productcode": cartitems?.d?[cartindex].productCode,
          "membershipno": prefs.getString('com_id'),
          "borderid": prefs.getString('orderid')
        });
        final response =
            await apiProvider.post(Appconstants.REMOVE_PRODUCT, requestJson);
        cartitems = CartModel.fromJson(response);
        orderid = cartitems?.d != null && cartitems!.d!.isNotEmpty
            ? (cartitems?.d?[0].orderid)
            : '';
        prefs.setString('orderid', orderid!);
        mapcartwithproducts();
        getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  removeallProducts() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "membershipno": prefs.getString('com_id'),
          "borderid": prefs.getString('orderid')
        });
        final response = await apiProvider.post(
            Appconstants.REMOVE_ALLPRODUCTS, requestJson);
        cartitems = CartModel.fromJson(response);
        orderid = cartitems?.d != null && cartitems!.d!.isNotEmpty
            ? (cartitems?.d?[0].orderid)
            : '';
        prefs.setString('orderid', orderid!);
        if (products != null) {
          mapcartwithproducts();
        }
        //getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  loginRemoveallProducts() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "membershipno": prefs.getString('com_id'),
          "borderid": prefs.getString('orderid')
        });
        final response = await apiProvider.post(
            Appconstants.REMOVE_ALLPRODUCTS, requestJson);
        cartitems = CartModel.fromJson(response);
        orderid = cartitems?.d != null && cartitems!.d!.isNotEmpty
            ? (cartitems?.d?[0].orderid)
            : '';
        prefs.setString('orderid', orderid!);
        if (products != null) {
          mapcartwithproducts();
        }
        //getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  checkout(deltype, slotid, String deliveryFlag) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "membershipno": prefs.getString('com_id'),
          "shopid": prefs.getString('shopid'),
          "slotid": slotid,
          "deltype": deltype,
          "orderid": prefs.getString('orderid'),
          "Warehouseid": prefs.getString('warehouseid'),
          "StoreLocationId": prefs.getString('storelocationid'),
          "NextdayDel": deliveryFlag
        });
        print('${requestJson}');
        final response =
            await apiProvider.post(Appconstants.CHECKOUT, requestJson);
        print('final checkout response --------${response["d"]}');
        notifyListeners();
        hideLoading();
        return response["d"];
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  getcartitems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int l = 0;
      print('cartlength${cartitems?.d?.length}');

      String requestJson = jsonEncode({
        "userId": prefs.getString('com_id'),
        "borderid": prefs.getString('orderid'),
        "shopid": prefs.getString("shopid"),
        "Warehouseid": prefs.getString('warehouseid'),
        "StoreLocationId": prefs.getString('storelocationid'),
      });
      print("GET CART");
      print("${requestJson}");
      final response =
          await apiProvider.post(Appconstants.GET_CART_ITEMS, requestJson);
      print("${response}");
      if (response["d"] == null) {
        return;
      }
      cartitems = CartModel?.fromJson(response);

      orderid = cartitems != null && cartitems!.d!.isNotEmpty
          ? (cartitems?.d?[0].orderid!)
          : '';
      print('object$orderid');
      numberOfItems = 0;
      if (cartitems == null) {
        l = 0;
      } else {
        l = cartitems!.d!.length;
      }
      for (int i = 0; i < l; i++) {
        numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
      }
      print('-jldijd$l' + '****${numberOfItems.toString()}');
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
    //return cartitems;
  }

  getcarttotal() async {
    //showLoading();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "userId": prefs.getString('com_id'),
          "borderid": prefs.getString('orderid'),
          "shopid": prefs.getString("shopid"),
          "Warehouseid": prefs.getString('warehouseid'),
          "StoreLocationId": prefs.getString('storelocationid'),
          "deltype": instorepickup == true ? "2" : "1"
        });
        print('${requestJson}');
        final response =
            await apiProvider.post(Appconstants.GET_CART_TOTAL, requestJson);
        if (response["d"] == null) {
          return;
        }
        cartTotal = CartTotalModel?.fromJson(response);

        notifyListeners();
      }
    } on SocketException {
      noInternet();
    } on Exception catch (e) {
      print(e);
    }
  }

  loadCoupons({action}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "membershipno": prefs.getString('com_id'),
          "orderid": action == "2" ? prefs.getString('orderid') : "",
          "Action": action
        });
        showLoading();
        final response =
            await apiProvider.post(Appconstants.LoadCoupons, requestJson);

        if (response != null && response["d"] != null) {
          hideLoading();
          loadCouponList = LoadCouponsModel.fromJson(response);
          notifyListeners();
          return "sucess";
        } else {
          loadCouponList?.d = [];
          hideLoading();
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    }
  }

  applyCoupon({rewardId, couponamt, coupon}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String requestJson = jsonEncode({
          "membershipno": prefs.getString('com_id'),
          "orderid": prefs.getString('orderid'),
          "RewardId": rewardId ?? "",
          "Coupon": coupon ?? "",
          "Couponamt": couponamt ?? ""
        });

        final response =
            await apiProvider.post(Appconstants.ApplyCoupon, requestJson);
        notifyListeners();
        hideLoading();
        return response["d"];
      }
    } on SocketException catch (e) {
      noInternet();
      print(e);
    }
  }
}
