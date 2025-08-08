import 'dart:convert';
import 'dart:io';

import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Models/WalletDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:delivoo/AppConstants.dart' as Appconstants;
import 'package:shared_preferences/shared_preferences.dart';
import '../Api_Provider.dart';
import '../Models/razorpayAuthModel.dart';
import '../payU_money/hash_service_model.dart';

class Paymentprovider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();
  String? sodexourl;
  String? razorpayId;
  String? webviewurl = 'www.amazon.com';
  WalletDetailsModel? walletdetails;
  RazorpayAuthModel? razorpayauth;
  String? transactionId;
  String? razorpaytxnId;
  String? orderId;
  // String? email;
  PayUHashModel? payUDetails;

  sodexopayment(usewallet) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("wallet $usewallet");
      print("orderid ${prefs.getString('orderid')}");
      print("membershipno ${prefs.getString("com_id")}");
      String requestJson = jsonEncode({
        "orderid": prefs.getString('orderid'),
        "membershipno": prefs.getString("com_id"),
        "usewallet": usewallet
      });
      print('%%%%%%%%%%%$usewallet');
      final response =
          await apiProvider.post(Appconstants.SODEXO_PAYMENT, requestJson);
      print(response["d"]["redirectUserTo"].toString());
      sodexourl = response["d"]["redirectUserTo"];
      transactionId = response["d"]["transactionId"];
      prefs.setString('txnId', transactionId.toString());
      print('uuuuuuuuuuu$transactionId');
      notifyListeners();
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  updatepaymentstatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String requestJson = jsonEncode({"orderid": prefs.getString('orderid')});
      final response =
          await apiProvider.post(Appconstants.PAY_STATUS, requestJson);
      print('paystatus' + response["d"]);

      notifyListeners();
      return response["d"];
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  getrazorpayId(usewallet) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("useWallet $usewallet");
        print("orderId ${prefs.getString('orderid')}");
        String requestJson = jsonEncode({
          "orderid": prefs.getString('orderid'),
          "membershipno": prefs.getString("com_id"),
          "usewallet": usewallet
        });

        final response =
            await apiProvider.post(Appconstants.RAZORPAY_ORDERID, requestJson);
        if (response != null && response["d"] != null) {
          hideLoading();
          print('razorpayId ' + response["d"]["RazorpayorderId"]);
          razorpayId = response["d"]["RazorpayorderId"];
          prefs.setString('failedRazorId', razorpayId.toString());
          print('razorpayTxnId ' + response["d"]["TrasactionId"]);
          razorpaytxnId = response["d"]["TrasactionId"];
          // email = response["d"]["EmailID"];
          prefs.setString('email', response["d"]["EmailID"]);
        } else {
          hideLoading();
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  getrazorpayreply(paymentId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Rezorpayorderid": razorpayId,
          "PaymentID": paymentId,
          "trasactionId": "",
          "PaymentStatus": "Success"
        });
        print(razorpayId.toString() + '-----' + paymentId);
        final response =
            await apiProvider.post(Appconstants.RAZORPAY_REPLY, requestJson);
        if (response != null) {
          hideLoading();
          orderId = response['d']['OrderNo'];
          return response['d']['PaymentStatus'];
        } else {
          hideLoading();
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  razorpayfail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Rezorpayorderid": razorpayId,
          "PaymentID": "",
          "trasactionId": "",
          "PaymentStatus": "fail"
        });
        print(razorpayId.toString() + '-----fail');
        final response =
            await apiProvider.post(Appconstants.RAZORPAY_REPLY, requestJson);
        print('razorpayreply ' + response["d"]['PaymentStatus'].toString());
        if (response["d"]['PaymentStatus'] == 'fail') {
          hideLoading();
          showMessage('Payment Failed');
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  paybywallet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "orderid": prefs.getString('orderid'),
          "membershipno": prefs.getString("com_id"),
          "shopId": prefs.getString("shopid")
        });
        print('-----paybywallet');
        final response =
            await apiProvider.post(Appconstants.PAY_BY_WALLET, requestJson);
        if (response != null || response['d'] != null) {
          orderId = response['d'];
        }
        notifyListeners();
        hideLoading();
        showMessage('Payment for order ${response["d"]} is successful');
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  getwalletdetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson =
            jsonEncode({"membeshipno": prefs.getString("com_id")});
        final response = await apiProvider.post(
            Appconstants.GET_WALLET_DETAILS, requestJson);
        walletdetails = WalletDetailsModel.fromJson(response);
        print('wallet details------ ' + response["d"].toString());
        notifyListeners();
        hideLoading();
        return walletdetails;
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  sodexowallet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('vvvvvvvvvvvvvv${prefs.getString('txnId')}');
        String requestJson = jsonEncode({
          "trasactionId": prefs.getString('txnId'),
          "orderid": prefs.getString('orderid')
        });
        final response =
            await apiProvider.post(Appconstants.SODEXO_WALLET, requestJson);
        // walletdetails = WalletDetailsModel.fromJson(response);
        print('wallet details------ ' + response["d"].toString());
        prefs.setString('txnId', '');
        notifyListeners();
        hideLoading();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  razorpayAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await apiProvider.authGet(
          Appconstants.razorpPayAuth + '${razorpayId}/payments',
          Appconstants.rzrpy,
          Appconstants.rzrpySecret,
        );
        if (response != null) {
          hideLoading();
          razorpayauth = await RazorpayAuthModel.fromJson(response);

          if (razorpayauth?.items.length == 0) {
            prefs.setString('failedRazorId', razorpayId.toString());
            await razorpayfail();
            return 'payment_failed';
          } else if (razorpayauth?.items.length != 0 &&
              razorpayauth?.items[0].status == 'failed') {
            prefs.setString('failedRazorId', razorpayId.toString());
            await razorpayfail();
            return 'payment_failed';
          } else if (razorpayauth?.items.length != 0 &&
              razorpayauth?.items[0].status == 'captured') {
            var resp = await getrazorpayreply(razorpayauth?.items[0].id);
            print('razorpayreply ' + response["d"].toString());
            return resp;
          }
        } else {
          hideLoading();
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      hideLoading();
      noInternet();
      print(e);
    }
  }

  checkrazorpayAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var payId = await prefs.getString('failedRazorId');
    print("razor pay failed id ${await prefs.getString('failedRazorId')}");
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await apiProvider.authGet(
          Appconstants.razorpPayAuth + '${payId}/payments',
          Appconstants.rzrpy,
          Appconstants.rzrpySecret,
        );
        if (response != null) {
          hideLoading();
          razorpayauth = await RazorpayAuthModel.fromJson(response);
          if (razorpayauth?.items.length != 0 &&
              razorpayauth?.items[0].status == 'captured') {
            var resp = await getrazorpayreply(razorpayauth?.items[0].id);
            print('razorpayreply ' + response["d"].toString());
            return resp;
          }
        } else {
          hideLoading();
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      hideLoading();
      noInternet();
      print(e);
    }
  }

  getPayUHash(usewallet) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "orderid": prefs.getString('orderid'),
          "categryid": prefs.getString('catId'),
          "membershipno": prefs.getString("com_id"),
          "gltype": "0",
          "usewallet": usewallet,
          "skuname": "Kisanservexpress"
        });
        final response =
            await apiProvider.post(Appconstants.PayUMoneyHash, requestJson);
        if (response != null && response["d"] != null) {
          hideLoading();
          payUDetails = PayUHashModel.fromJson(response);
        } else {
          hideLoading();
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  getPayUreply(PayuTrasactionId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({"PayuTrasactionId": PayuTrasactionId});
        print('-----' + PayuTrasactionId);
        final response =
            await apiProvider.post(Appconstants.PayUReply, requestJson);
        if (response != null) {
          hideLoading();
          orderId = response['d']['orderno'];
        } else {
          hideLoading();
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  getPayUreplyCancel(PayuTrasactionId, response) async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "PayuTrasactionId": PayuTrasactionId,
          "orderstatus": "Cancel",
          "failure_message": response
        });
        print('-----' + PayuTrasactionId);
        await apiProvider.post(Appconstants.PayUReplyCancel, requestJson);
        notifyListeners();
      }
    } on SocketException catch (e) {
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }
}
