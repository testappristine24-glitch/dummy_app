// To parse this JSON data, do
//
//     final cartTotalModel = cartTotalModelFromJson(jsonString);

import 'dart:convert';

CartTotalModel cartTotalModelFromJson(String str) =>
    CartTotalModel.fromJson(json.decode(str));

String cartTotalModelToJson(CartTotalModel data) => json.encode(data.toJson());

class CartTotalModel {
  CartTotalModel({
    this.d,
  });

  List<D>? d;

  factory CartTotalModel.fromJson(Map<String, dynamic> json) => CartTotalModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.totalQty,
    this.totalWeight,
    this.totalcount,
    this.pretaxamount,
    this.posttaxamount,
    this.cgsttax,
    this.sgsttax,
    this.igsttax,
    this.savingamount,
    this.minimumbasket,
    this.orderid,
    this.walletamt,
    this.payamt,
    this.delcharge,
    this.subtotal,
    this.dicountper,
    this.dicountamt,
    this.couponName,
    this.couponamt,
    this.subtotalfinal,
    this.Deliverydate,
    this.nextslotmsg,
  });

  String? type;
  String? totalQty;
  String? totalWeight;
  String? totalcount;
  dynamic pretaxamount;
  String? posttaxamount;
  String? cgsttax;
  String? sgsttax;
  String? igsttax;
  String? savingamount;
  int? minimumbasket;
  String? orderid;
  String? walletamt;
  String? payamt;
  String? delcharge;
  String? subtotal;
  String? dicountper;
  String? dicountamt;
  String? couponName;
  String? couponamt;
  String? subtotalfinal;
  String? Deliverydate;
  String? nextslotmsg;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        totalQty: json["totalQty"],
        totalWeight: json["totalWeight"],
        totalcount: json["totalcount"],
        pretaxamount: json["pretaxamount"],
        posttaxamount: json["posttaxamount"],
        cgsttax: json["cgsttax"],
        sgsttax: json["sgsttax"],
        igsttax: json["Igsttax"],
        savingamount: json["Savingamount"],
        minimumbasket: json["Minimumbasket"],
        orderid: json["Orderid"],
        walletamt: json["Walletamt"],
        payamt: json["payamt"],
        delcharge: json["Delcharge"],
        subtotal: json["subtotal"],
        dicountper: json["Dicountper"],
        dicountamt: json["Dicountamt"],
        couponName: json["CouponName"],
        couponamt: json["Couponamt"],
        subtotalfinal: json["subtotalfinal"],
    Deliverydate: json["Deliverydate"],
    nextslotmsg: json["nextslotmsg"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "totalQty": totalQty,
        "totalWeight": totalWeight,
        "totalcount": totalcount,
        "pretaxamount": pretaxamount,
        "posttaxamount": posttaxamount,
        "cgsttax": cgsttax,
        "sgsttax": sgsttax,
        "Igsttax": igsttax,
        "Savingamount": savingamount,
        "Minimumbasket": minimumbasket,
        "Orderid": orderid,
        "Walletamt": walletamt,
        "payamt": payamt,
        "Delcharge": delcharge,
        "subtotal": subtotal,
        "Dicountper": dicountper,
        "Dicountamt": dicountamt,
        "CouponName": couponName,
        "Couponamt": couponamt,
        "subtotalfinal": subtotalfinal,
    "Deliverydate": Deliverydate,
    "nextslotmsg": nextslotmsg,
      };
}
