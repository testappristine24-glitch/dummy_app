// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:delivoo/AppConstants.dart' as Appconstants;
import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Models/OrderModel.dart' as Order;
import 'package:delivoo/Models/OrderdetailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orderprovider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  Order.OrderModel? orders;
  Order.D? selectedOrder;

  OrderdetailModel? orderdetails;
  D? orderdetail;

  int? orderindex;
  List<bool> expand = [];
  List<String> items = [];
  var firstDay;
  var lastDay;
  int? present;
  bool? isloading = false;

  toggle(index) {
    expand[index] = !expand[index];
    notifyListeners();
  }

  DatePickerFirstDay(value) async {
    firstDay = DateFormat('dd/MM/yyyy').format(value);
    notifyListeners();
  }

  DatePickerLastDay(value) async {
    lastDay = DateFormat('dd/MM/yyyy').format(value);
    notifyListeners();
  }

  getorders(frm, to, odrNo, ispresent) async {
    // showLoading();
    try {
      isloading = true;
      present = ispresent;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //String? userId = prefs.getString('userid');
      String requestJson = jsonEncode({
        "membeshipno": prefs.getString('com_id'),
        "Pastorder": "$ispresent",
        "frmdeldate": "",
        "todeldate": "",
        "orderno": ""
      });
      print("$requestJson");
      final response =
          await apiProvider.post(Appconstants.GET_ORDERS, requestJson);
      if (response == null) {
        orders = null;
        isloading = false;
        notifyListeners();
        return;
      }
      orders = Order.OrderModel.fromJson(response);
      items = List.generate(orders!.d!.length,
          (index) => orders!.d![index].customerName.toString());

      //await processresponse();
      //expand = List<bool>.generate(orders.length, (int index) => false);
      notifyListeners();
      isloading = false;
      // hideLoading();
    } on SocketException catch (e) {
      isloading = false;

      notifyListeners();
      noInternet();
      // showMessage('No Internet connection');
      print(e);
    }
  }

  getorderdetails(orderid, oindex) async {
    orderindex = oindex;
    selectedOrder = orders?.d?.elementAt(oindex);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String? userId = prefs.getString('userid');
    String requestJson = jsonEncode({"orderid": orderid});
    final response =
        await apiProvider.post(Appconstants.GET_ORDER_DETAILS, requestJson);
    orderdetails = OrderdetailModel.fromJson(response);
    //await processresponse();
    //expand = List<bool>.generate(orders.length, (int index) => false);
    notifyListeners();
  }

  updateorder() {
    notifyListeners();
  }

  getorderid() {}
}
