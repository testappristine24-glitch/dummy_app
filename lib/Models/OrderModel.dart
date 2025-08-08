// // To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.d,
  });

  List<D>? d;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.orderid,
    this.orderNo,
    this.itemCount,
    this.qty,
    this.wt,
    this.customerName,
    this.delivaryLocatrion,
    this.delAddress,
    this.mobileNo,
    this.orderStatus,
    this.paymentStatus,
    this.paymentmode,
    this.deltype,
    this.delSlot,
    this.delstarttime,
    this.delendtime,
    this.orderDate,
    this.deliverydate,
    this.totalamount,
    this.storeLOcation,
    this.deliveryCharge,
    this.shoplatitude,
    this.shoplongitude,
    this.orderPin,
    this.delboyMobile,
    this.mapAddress,
    this.longitude,
    this.latitude,
    this.delboyName,
    this.delTime,
    this.ratings,
    this.ratingStatus,
  });

  String? type;
  String? orderid;
  String? orderNo;
  String? itemCount;
  String? qty;
  String? wt;
  String? customerName;
  String? delivaryLocatrion;
  String? delAddress;
  String? mobileNo;
  String? orderStatus;
  String? paymentStatus;
  String? paymentmode;
  String? deltype;
  String? delSlot;
  String? delstarttime;
  String? delendtime;
  String? orderDate;
  String? deliverydate;
  String? totalamount;
  String? storeLOcation;
  String? deliveryCharge;
  String? shoplongitude;
  String? shoplatitude;
  String? orderPin;
  String? delboyMobile;
  String? mapAddress;
  dynamic longitude;
  dynamic latitude;
  dynamic delboyName;
  dynamic delTime;
  String? ratings;
  String? ratingStatus;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        orderid: json["orderid"],
        orderNo: json["orderNo"],
        itemCount: json["ItemCount"],
        qty: json["Qty"],
        wt: json["wt"],
        customerName: json["CustomerName"],
        delivaryLocatrion: json["DelivaryLocatrion"],
        delAddress: json["DelAddress"],
        mobileNo: json["MobileNo"],
        orderStatus: json["OrderStatus"],
        paymentStatus: json["PaymentStatus"],
        paymentmode: json["Paymentmode"],
        deltype: json["Deltype"],
        delSlot: json["DelSlot"],
        delstarttime: json["Delstarttime"],
        delendtime: json["Delendtime"],
        orderDate: json["OrderDate"],
        deliverydate: json["Deliverydate"],
        totalamount: json["Totalamount"],
        storeLOcation: json["StoreLOcation"],
        deliveryCharge: json["DeliveryCharge"],
        shoplatitude: json["shoplatitude"],
        shoplongitude: json["shoplongitude"],
        orderPin: json["OrderPin"],
        delboyMobile: json["DelboyMobile"],
        mapAddress: json["MapAddress"],
        longitude: json["Longitude"],
        latitude: json["Latitude"],
        delboyName: json["DelboyName"],
        delTime: json["DelTime"],
        ratings: json["Ratings"],
        ratingStatus: json["RatingStatus"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "orderid": orderid,
        "orderNo": orderNo,
        "ItemCount": itemCount,
        "Qty": qty,
        "wt": wt,
        "CustomerName": customerName,
        "DelivaryLocatrion": delivaryLocatrion,
        "DelAddress": delAddress,
        "MobileNo": mobileNo,
        "OrderStatus": orderStatus,
        "PaymentStatus": paymentStatus,
        "Paymentmode": paymentmode,
        "Deltype": deltype,
        "DelSlot": delSlot,
        "Delstarttime": delstarttime,
        "Delendtime": delendtime,
        "OrderDate": orderDate,
        "Deliverydate": deliverydate,
        "Totalamount": totalamount,
        "StoreLOcation": storeLOcation,
        "DeliveryCharge": deliveryCharge,
        "shoplatitude": shoplatitude,
        "shoplongitude": shoplongitude,
        "OrderPin": orderPin,
        "DelboyMobile": delboyMobile,
        "MapAddress": mapAddress,
        "Longitude": longitude,
        "Latitude": latitude,
        "DelboyName": delboyName,
        "DelTime": delTime,
        "Ratings": ratings,
        "RatingStatus": ratingStatus,
      };
}
